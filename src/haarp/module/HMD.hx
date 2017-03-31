package haarp.module;

import haxe.Json;
import js.Promise;
import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.node.Buffer;
import js.node.Net;
import js.node.net.Server;
import js.node.net.Socket;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.rtc.DataChannel;
import js.html.MediaStream;
import js.html.MediaStreamTrack;
import js.html.rtc.IceCandidate;
import js.html.rtc.PeerConnection;
import js.html.rtc.SessionDescription;
import om.net.WebSocket;

/*
typedef Orientation = {
    var alpha : Float;
    var beta : Float;
    var gamma : Float;
}
*/

private class Client {

    public dynamic function onMessage( msg : Dynamic ) {}

    public var connected(default,null) = false;
    //public var orientation(default,null) : Orientation;

    var socket : Socket;
    var peer : PeerConnection;
    var channel : DataChannel;
    var stream : MediaStream;
    var canvas : CanvasElement;
    var context : CanvasRenderingContext2D;

    public function new( socket : Socket, width : Int, height : Int ) {

        this.socket = socket;

        socket.once( 'data', function( buf : Buffer ) {
            socket.write( WebSocket.createHandshake( buf ) );
            socket.addListener( 'data', handleData );
        });

        canvas = document.createCanvasElement();
        canvas.width = width;
        canvas.height = height;
        canvas.style.position = 'fixed';
        canvas.style.zIndex = '-1';
        document.body.appendChild( canvas );

        context = canvas.getContext2d();
        //context.imageSmoothingEnabled = false;
        context.fillStyle = '#0000ff';
        context.font = '11px Anonymous Pro';
    }

    function handleData( buf : Buffer ) {

        var msg : Dynamic;
        try {
            var data = WebSocket.readFrame( buf );
            if( data == null ) {
                trace('??? data == null');
                return;
            }
            msg = Json.parse( data.toString() );
        } catch(e:Dynamic) {
            console.error( 'failed to read websocket frame\n'+buf[0] );
            return;
        }

        trace( msg );

        switch msg.type {

        case "init":

            //TODO calculate size for video stream
            //trace(msg.size);
            canvas.width = Std.int( msg.size.width/2 );
            canvas.height = Std.int( msg.size.height );

            peer = untyped __js__( 'new webkitRTCPeerConnection({iceServers:[]})' );
            peer.onicecandidate = function(e) {
                if( e.candidate == null ) {
                    trace("Send init");
                    sendSocketMessage( { type: 'init', sdp: peer.localDescription } );
                }
            }

            channel = peer.createDataChannel( "channel-1" );
            channel.onopen = function(e) {
                trace(e);
                console.log( 'HMD connected' );
                //sendMessage( { type:"fuxk", value:23 } );
                //connected = true;
                //channel.send( 'ping' );
            }
            channel.onmessage = function(e) {
                onMessage( Json.parse( e.data ) );
                //Timer.delay( function() sendChannel.send( 'ping' ), 1000 );
            }
            channel.onclose = function(e) trace(e);

            stream = untyped canvas.captureStream();
            //peer.addTrack( stream );
            peer.addStream( stream );

            peer.createOffer( { offerToReceiveAudio: 0,	offerToReceiveVideo: 1 } )
                .then( function(desc) peer.setLocalDescription( desc ) )
                .then( function(_) {
                    trace("...............");
                    //sendSocketMessage( { type: 'init', sdp: peer.localDescription } );
                });

        case 'sdp':
            peer.setRemoteDescription( new SessionDescription( msg.sdp ) ).then( function(e){
                //console.log( 'HMD connected' );
                //connected = true;
                //socket.end();
            });
        }
    }

    public inline function sendMessage( msg : Dynamic ) {
        send( Json.stringify( msg ) );
    }

    public inline function send( str : String ) {
        channel.send( str );
    }

    public function render( src : CanvasElement ) {

        context.save();
        context.scale( canvas.width / src.width, canvas.height / src.height / 2 );
        context.drawImage( src, 0, 0 );
        context.restore();

        //context.drawImage( src, 0, 0 );
        //context.fillStyle = '#00ff00';
        //context.fillRect( 0, 0, 200, 400 );
    }

    public function disconnect() {
        if( peer != null ) {
            peer.close();
        }
        if( socket != null ) {
            socket.end();
        }
    }

    inline function sendSocketMessage( msg : Dynamic )
        sendSocket( Json.stringify( msg )  );

    function sendSocket( str : String ) {
        try socket.write( WebSocket.writeFrame( new Buffer( str ) ) ) catch(e:Dynamic) {
            console.error(e);
        }
    }
}

class HMD extends Module {

    public dynamic function onMessage( msg : Dynamic ) {}

    var ip : String;
    var port : Int;
    var server : Server;
    var clients : Array<Client>;
    var canvas : CanvasElement;
    var context : CanvasRenderingContext2D;

    public function new( ip : String, port : Int ) {

        super();
        this.ip = ip;
        this.port = port;

        canvas = document.createCanvasElement();
        canvas.style.position = 'fixed';
        canvas.style.zIndex = '-1';
        document.body.appendChild( canvas );

        context = canvas.getContext2d();
        context.imageSmoothingEnabled = false;
        context.fillStyle = '#000';
        context.font = '11px Anonymous Pro';
    }

    override function init() {

        canvas.width = vision.display.width;
        canvas.height = vision.display.height;

        clients = [];

        trace( 'Starting HMD host server' );

        return new Promise( function(resolve,reject){

            server = Net.createServer( function(socket:Socket) {

                console.log( "Socket connected" );

                var client = new Client( socket, vision.display.width, vision.display.height );
                client.onMessage = onMessage;
                clients.push( client );

                socket.once( 'close', function(e) {
                    trace( e );
                    clients.remove( client );
                });
            });
            server.listen( port, ip, function() {

                window.addEventListener( 'resize', handleWindowResize, false  );

                resolve( cast this );
            });
        });
    }

    override function render() {

        if( clients.length > 0 ) {

            //context.clearRect( 0, 0, canvas.width, canvas.height );
            //context.drawImage( vision.display.canvas, 0, 0, canvas.width, canvas.height );
            //context.drawImage( vision.display.canvas, 0, 0 );

            /*
            //context.font = '11px Anonymous Pro';

            for( client in clients ) {
                client.render( canvas );
                //client.render( vision.display.canvas );
            }
            */

            //context.fillStyle = '#00ffff';
            //context.fillRect( 0, 0, 100, 400 );
            //context.drawImage( vision.display.canvas, 0, 0 );

            //context.save();
            context.drawImage( vision.display.canvas, 0, 0 );
            //ontext.globalCompositeOperation = 'screen';
            context.fillText( vision.name, 2, 10 );
            context.fillText( ''+Std.int( vision.time ), 2, 22 );
            //context.restore();

            for( client in clients ) {
                client.render( canvas );
            }
        }
    }

    function handleWindowResize(e) {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    }

    public function send( msg : Dynamic ) {
        var str = Json.stringify( msg );
        for( client in clients ) {
            if( client.connected ) {
                client.send( str );
            }
        }
    }
}
