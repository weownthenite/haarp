package haarp.module;

import js.Promise;
import js.Browser.document;
import js.Browser.window;
import js.html.audio.AudioBuffer;
import js.html.audio.AudioBufferSourceNode;
import om.Time;
import om.audio.AudioBufferLoader;

class Sound extends Module {

    public var path(default,null) : String;
    public var loop : Bool;

    var buffer(default,null) : AudioBuffer;
    //public var buffer(default,null) : AudioBuffer;

    public var duration(get,null) : Float;
    inline function get_duration() return buffer.duration;

    public var time(get,null) : Float;
    inline function get_time() return (Time.now() - startTime) / 1000;
    //inline function get_time() return vision.audio.time - startTime;

    public var startOffset : Float;

    var source : AudioBufferSourceNode;
    var startTime : Float;

    public function new( path : String, loop = false, startOffset = 0.0 ) {
        super();
        this.path = path;
        this.loop = loop;
        this.startOffset = startOffset;
    }

    override function init() {
        return cast load( path );
    }

    override function start() {

        startTime = vision.frameTime;

        source = vision.audio.context.createBufferSource();
        source.onended = function() if( loop ) start();
        source.buffer = buffer;
        source.start( 0, startOffset );

        vision.audio.connect( source );
    }

    /*
    override function update( time : Float ) {
        this.time = time - startTime;
    }
    */

    override function stop() {
        if( source != null ) {
            source.onended = null;
            source.stop();
            source = null;
        }
    }

    public function load( path : String ) {
        if( source != null ) stop();
        return vision.audio.load( path ).then( function(buf) {
            this.buffer = buf;
            return Promise.resolve( this );
        });
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
