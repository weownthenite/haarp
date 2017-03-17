package haarp.module;

import js.Browser.console;
import js.node.Buffer;
import js.node.Net;
import js.node.net.Server;
import js.node.net.Socket;
import js.html.rtc.IceCandidate;
import js.html.rtc.PeerConnection;
import js.html.rtc.SessionDescription;
import om.net.WebSocket;
import haxe.Json;

private class Client {

    public dynamic function onDisconnect() {}
    public dynamic function onMessage( msg : Dynamic ) {}

    var socket : Socket;
    var handshaked : Bool;

    public function new( socket : Socket ) {
        this.socket = socket;
        handshaked = false;
        socket.once( 'data', function( buf : Buffer ) {
            socket.write( WebSocket.createHandshake( buf ) );
            handshaked = true;
            socket.addListener( 'data', handleData );
        } );
    }

    public function sendString( str : String ) {
        try socket.write( WebSocket.writeFrame( new Buffer( str ) ) ) catch(e:Dynamic) {
            trace(e);
        }
    }

    public inline function sendMessage( msg : Dynamic ) {
        sendString( Json.stringify( msg )  );
    }

    function handleData( buf : Buffer ) {
        var data = WebSocket.readFrame( buf );
        if( data == null ) {
            console.warn( 'Failed to read websocket frame\n'+buf[0] );
        } else {
            var msg = try Json.parse( data.toString() ) catch(e:Dynamic) {
                console.error( e );
                return;
            }
            onMessage( msg );
        }
    }
}

class HMDHost extends Module {

    public var ip(default,null) : String;
    public var port(default,null) : Int;

    var server : Server;
    var peer : PeerConnection;
    var iceCandidates : Array<IceCandidate>;
    var clients : Array<Client>;

    public function new( ip : String, port : Int ) {
        super();
        this.ip = ip;
        this.port = port;
    }

    override function init( ?callback : Void->Void ) {

        clients = [];
        iceCandidates = [];

        peer = untyped __js__( 'new webkitRTCPeerConnection({iceServers:[]})' );
        peer.onicecandidate = function(e) {
            //trace(e); //TODO seems to work without sending candidates on local network
        }

        var stream = vision.display.captureStream();
        peer.addStream( stream );

        peer.createOffer( { offerToReceiveAudio: 0,	offerToReceiveVideo: 1 } )
            .then( function(desc) peer.setLocalDescription( desc ) )
            .then( function(_) {

                server = Net.createServer( function(socket:Socket) {
                    var client = new Client( socket );
                    client.onMessage = function(msg) {
                        trace(msg);
                        switch msg.type {
                        case 'boot':
                            client.sendMessage( { sdp: peer.localDescription } );
                        case 'sdp':
                            peer.setRemoteDescription( new SessionDescription( msg.sdp ) ).then( function(e){
                                trace('Set remote success');
                            });
                        }
                    }
                    client.onDisconnect = function() {
                        trace( "Client disconnected" );
                        clients.remove( client );
                    }
                    clients.push( client );
                });

                server.listen( port, ip, function() {
                    callback();
                });
            }
        );
    }

    override function stop() {
        peer.close();
        server.close();
        clients = [];
        iceCandidates = [];
    }
}
