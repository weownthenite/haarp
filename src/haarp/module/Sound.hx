package haarp.module;

import js.Browser.document;
import js.Browser.window;
import js.html.audio.AudioBuffer;
import js.html.audio.AudioBufferSourceNode;
import om.audio.AudioBufferLoader;

class Sound extends Module {

    public var url(default,null) : String;
    public var source(default,null) : AudioBufferSourceNode;

    public function new( url : String ) {
        super();
        this.url = url;
    }

    override function init( ?callback : Void->Void ) {

        var audio = vision.sound.context;

        AudioBufferLoader.loadAudioBuffer( audio, url ).then( function(buf){

            source = audio.createBufferSource();
            source.buffer = buf;
            vision.sound.connect( source );

            callback();
        });
    }

    override function start() {
        source.start();
    }

    override function stop() {
        source.stop();
    }

    override function update() {
    }

}
