package haarp.module;

import js.Promise;
import js.html.audio.AudioBuffer;
import js.html.audio.AudioBufferSourceNode;
import js.html.audio.AudioNode;
import om.Time;
import om.audio.AudioBufferLoader;

class Sound extends Module {

    public var path(default,null) : String;
    public var startOffset(default,null) : Float;
    public var loop : Bool;

    public var node(get,never) : AudioNode;
    inline function get_node() return source;

    public var duration(get,null) : Float;
    inline function get_duration() return buffer.duration;

    //public var time(get,null) : Float;
    //inline function get_time() return (Time.now() - startTime) / 1000;
    //inline function get_time() return vision.audio.time - startTime;

    var buffer : AudioBuffer;
    var source : AudioBufferSourceNode;
    var timeStart : Float;
    var timePauseStart : Float;

    public function new( path : String, loop = false, startOffset = 0.0 ) {
        super();
        this.path = path;
        this.loop = loop;
        this.startOffset = startOffset;
        timeStart = 0;
        timePauseStart = 0;
    }

    override function init() {
        return cast load( path );
    }

    override function start() {

        source = vision.audio.context.createBufferSource();
        source.onended = function() if( loop ) start();
        source.buffer = buffer;

        if( timePauseStart > 0 ) {
            timeStart = Time.now() - timePauseStart;
            source.start( 0, timePauseStart / 1000 );
        } else {
            timeStart = Time.now();
            source.start();
        }
    }

    override function stop() {
        source.onended = null;
        source.stop();
    }

    override function pause() {
        source.stop();
        timePauseStart = Time.now() - timeStart;
    }

    override function resume() {
        start();
    }

    public function load( path : String ) {
        if( source != null ) stop();
        return vision.audio.load( path ).then( function(buf) {
            buffer = buf;
            return Promise.resolve( this );
        });
    }

}
