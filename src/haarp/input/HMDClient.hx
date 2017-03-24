package haarp.input;

import haxe.Json;
import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.Promise;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.MediaStream;
import js.html.WebSocket;
import js.html.rtc.DataChannel;
import js.html.rtc.IceCandidate;
import js.html.rtc.PeerConnection;
import js.html.rtc.SessionDescription;

class HMDClient {

    public dynamic function onMessage( msg : Dynamic ) {}
    public dynamic function onStream( stream : MediaStream ) {}

    var ip : String;
    var port : Int;
    var socket : WebSocket;
    var peer : PeerConnection;
    var channel : DataChannel;
    //var stream : MediaStream;

    public function new( ip : String, port : Int ) {
        this.ip = ip;
        this.port = port;
    }

    public function connect() : Promise<Dynamic> {

        trace( 'Connecting to HMD host ...' );

        return new Promise( function(resolve,reject){

            var url = 'ws://$ip:$port';
            socket = new WebSocket( url );
            socket.addEventListener( 'open', function(e) {
                sendSocketMessage( {
                    type: 'init',
                    size: {
                        width: Std.int( window.innerWidth / 2 ),
                        height: Std.int( window.innerHeight )
                    }
                } );
            });
            socket.addEventListener( 'error', function(e) trace(e) );
            socket.addEventListener( 'close', function(e) trace(e) );
            socket.addEventListener( 'message', function(e) {

                var msg : Dynamic = try Json.parse( e.data ) catch(e:Dynamic) {
                    console.error( e );
                    return;
                }

                //trace(msg);

                switch msg.type {

                case 'init':

                    peer = new PeerConnection();

                    peer.onicecandidate = function(e) {
                        //trace(e);
                        /*
                        if( e.candidate != null ) {
                            sendMessage( { type: 'ice', candidate: e.candidate } );
                        }
                        */
                    }

                    peer.onaddstream = function(e) {
                        //console.log( 'Add stream' );
                        trace(e.stream);
                        //stream = e.stream;
                        onStream( e.stream );
                    }

                    peer.ondatachannel = function(e) {
                        trace(e);
                        channel = e.channel;
                        channel.onopen = function(e) {
                            trace(e);
                            resolve( {} );
                        }
                        channel.onclose = function(e) trace(e);
            			channel.onmessage = function(e) {
                            onMessage( Json.parse( e.data ) );
            				//haxe.Timer.delay( function() channel.send( 'pong' ), 1000 );
            			}
                    }

                    peer.setRemoteDescription( new SessionDescription( msg.sdp ) ).then( function(_) {
                        peer.createAnswer().then( function(desc){
                            peer.setLocalDescription( desc ).then( function(_){
                                sendSocketMessage( { type: 'sdp', sdp: desc } );
                                trace( " CONECTED" );
                                //replace( new VisionActivity( socket, stream ) );
                            });
                        });
                    }).catchError( function(e){
                        trace(e);
                        //TODO
                    });
                }
            });
        });
    }

    public function disconnect() {
        if( socket != null ) {
            socket.close();
        }
        if( peer != null ) {
            peer.close();
        }
    }

    public inline function send( msg : Dynamic ) {
        channel.send( Json.stringify( msg ) );
    }

    inline function sendSocketMessage( msg : Dynamic ) {
        socket.send( Json.stringify( msg ) );
    }

}
