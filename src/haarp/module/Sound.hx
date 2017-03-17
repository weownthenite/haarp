package haarp.module;

import js.Browser.document;
import js.Browser.window;
import js.html.audio.AudioBuffer;
import js.html.audio.AudioBufferSourceNode;
import om.audio.AudioBufferLoader;

class Sound extends Module {

    public var url(default,null) : String;
    public var loop : Bool;

    var buf : AudioBuffer;
    var source : AudioBufferSourceNode;

    public function new( url : String, loop = false ) {
        super();
        this.url = url;
        this.loop = loop;
    }

    override function init( ?callback : Void->Void ) {
        load( url, function( buf ) {
            this.buf = buf;
            //createSourceNode();
            callback();
        } );
    }

    override function start() {
        source = vision.sound.context.createBufferSource();
        source.onended = function() if( loop ) start();
        source.buffer = buf;
        source.start();
        vision.sound.connect( source );
    }

    override function stop() {
        if( source != null ) {
            source.onended = null;
            source.stop();
            source = null;
        }
    }

    public function load( url : String, callback : AudioBuffer->Void ) {
        if( source != null ) source.stop();
        vision.sound.load( url, callback );
    }

    /*
    function createSourceNode() {
        source = vision.sound.context.createBufferSource();
        source.buffer = buf;
        source.onended = function(){
            if( loop ) {
                createSourceNode();
                start();
            }
        }
        vision.sound.connect( source );
    }
    */

}
