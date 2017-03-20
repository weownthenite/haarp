package haarp.module;

import js.Browser.console;
import js.Browser.document;
import js.node.Buffer;
import js.node.Net;
import js.node.net.Server;
import js.node.net.Socket;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.rtc.IceCandidate;
import js.html.rtc.PeerConnection;
import js.html.rtc.SessionDescription;
import om.net.WebSocket;
import haxe.Json;

private class Client {

    public dynamic function onDisconnect() {}

    var socket : Socket;
    var handshaked : Bool;
    var peer : PeerConnection;
    var canvas : CanvasElement;
    var context : CanvasRenderingContext2D;

    public function new( socket : Socket ) {

        this.socket = socket;

        handshaked = false;

        socket.once( 'close', function(e) {
            trace( e );
            //socket.removeListener( 'data', handleData );
            onDisconnect();
        });
        socket.once( 'data', function( buf : Buffer ) {
            socket.write( WebSocket.createHandshake( buf ) );
            handshaked = true;
            socket.addListener( 'data', handleData );
        });

        canvas = document.createCanvasElement();
        canvas.style.position = 'fixed';
        canvas.style.zIndex = '-1';
        document.body.appendChild( canvas );

        context = canvas.getContext2d();
        context.fillStyle = '#0000ff';
        context.font = '100px Noto Sans';
    }

    function handleData( buf : Buffer ) {

        var msg : Dynamic;
        try {
            var data = WebSocket.readFrame( buf );
            if( data == null ) {
                trace('??? data == null');
                return;
            }
            msg = try Json.parse( data.toString() ) catch(e:Dynamic) {
                console.error( e );
                return;
            }
            trace(msg);
        } catch(e:Dynamic) {
            console.error( 'failed to read websocket frame\n'+buf[0] );
            return;
        }

        switch msg.type {

        case "init":

            peer = untyped __js__( 'new webkitRTCPeerConnection({iceServers:[]})' );
            peer.onicecandidate = function(e) {
                if( e.candidate == null ) {
                    sendMessage( { type: 'init', sdp: peer.localDescription } );
                }
            }

            canvas.width = msg.size.width;
            canvas.height = msg.size.height;

            var stream = untyped canvas.captureStream();
            //peer.addTrack( stream );
            peer.addStream( stream );

            /*
            var videoTracks = stream.getVideoTracks();
            if( videoTracks.length > 0 ) {
                trace( 'Using video device: ' + videoTracks[0].label );
                trace( videoTracks );
            }
            //var audioTracks = stream.getAudioTracks();
            //if( audioTracks.length > 0 ) trace( 'Using audio device: ' + audioTracks[0].label) ;
            */

            var channel = peer.createDataChannel( "channel-1" );
            channel.onopen = function(e) {
                trace(e);
                channel.send( 'ping' );
            }
            channel.onmessage = function(e) {
                trace(e);
                //Timer.delay( function() sendChannel.send( 'ping' ), 1000 );
            }
            channel.onclose = function(e) trace(e);

            peer.createOffer( { offerToReceiveAudio: 0,	offerToReceiveVideo: 1 } )
                .then( function(desc) peer.setLocalDescription( desc ) )
                .then( function(_) {
                    //trace("...............");
                    //sendMessage( { type: 'init', sdp: peer.localDescription } );
                });

        case 'sdp':
            peer.setRemoteDescription( new SessionDescription( msg.sdp ) ).then( function(e){
                console.log( 'HMD connected' );
                //socket.end();
            });
        }
    }

    public inline function sendMessage( msg : Dynamic )
        sendString( Json.stringify( msg )  );

    public function sendString( str : String ) {
        try socket.write( WebSocket.writeFrame( new Buffer( str ) ) ) catch(e:Dynamic) {
            console.error(e);
        }
    }

    public function render( src : CanvasElement ) {
        context.clearRect( 0, 0, canvas.width, canvas.height );
        context.drawImage( src, 0, 0 );
        //context.fillRect( 0, 0, 200, 100 );
    }

    public function disconnect() {
        if( peer != null ) {
            peer.close();
        }
        if( socket != null ) {
            socket.end();
        }
    }
}

class HMDHost extends AbstractModule {

    public var ip(default,null) : String;
    public var port(default,null) : Int;

    var server : Server;
    var clients : Array<Client>;
    var canvas : CanvasElement;
    var context : CanvasRenderingContext2D;

    public function new( ip : String, port : Int ) {
        super();
        this.ip = ip;
        this.port = port;
    }

    override function init( ?callback : Void->Void ) {

        canvas = document.createCanvasElement();
        canvas.width = vision.display.width;
        canvas.height = vision.display.height;
        canvas.style.position = 'fixed';
        canvas.style.zIndex = '-1';
        document.body.appendChild( canvas );

        context = canvas.getContext2d();
        context.fillStyle = '#00ff00';
        context.font = '100px Noto Sans';

        clients = [];

        server = Net.createServer( function(socket:Socket) {
            console.log( "Socket connected" );
            var client = new Client( socket );
            client.onDisconnect = function() {
                console.log( "Client disconnected" );
                clients.remove( client );
            }
            clients.push( client );
        });
        server.listen( port, ip, function() {
            callback();
        });

        //TODO get sound waveform
    }

    override function render() {

        context.clearRect( 0, 0, canvas.width, canvas.height );
        context.drawImage( vision.display.canvas, 0, 0, canvas.width, canvas.height );

        context.font = '60px Noto Sans';
        context.fillText( ''+Std.string( Std.int(om.Time.now()) ), 20, 100 );

        for( client in clients ) {
            client.render( canvas );
            //client.render( vision.display.canvas );
        }

        //TODO render ui
    }

    override function stop() {
        for( client in clients ) {
            client.disconnect();
        }
        clients = [];
        server.close();
    }
}
