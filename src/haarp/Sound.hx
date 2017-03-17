package haarp;

import js.html.Uint8Array;
import js.html.audio.AudioContext;
import js.html.audio.AudioBuffer;
import js.html.audio.AudioBufferSourceNode;
import js.html.audio.AnalyserNode;
import js.html.audio.GainNode;
import om.audio.AudioBufferLoader;

class Sound {

    public var context(default,null) : AudioContext;

    public var volume(get,set) : Float;
    inline function get_volume() return gain.gain.value;
    inline function set_volume(v) return gain.gain.value = v;

    public var frequencyData(default,null) : Uint8Array;
    public var timeDomainData(default,null) : Uint8Array;

    var gain : GainNode;
    var analyser : AnalyserNode;

    public function new( volume = 1.0 ) {

        context = new AudioContext();

        gain = context.createGain();
		gain.gain.value = volume;

        //meter = new VolumeMeter( context );

        analyser = context.createAnalyser();
		analyser.fftSize = 1024;

        frequencyData = new Uint8Array( analyser.frequencyBinCount );
		timeDomainData = new Uint8Array( analyser.frequencyBinCount );

        gain.connect( analyser );
        analyser.connect( context.destination );
    }

    public function connect( node : AudioBufferSourceNode ) {
        node.connect( gain );
    }

    public function update() {
        analyser.getByteFrequencyData( frequencyData );
        analyser.getByteTimeDomainData( timeDomainData );
    }

    public function load( url : String, callback : AudioBuffer->Void ) {
        AudioBufferLoader.loadAudioBuffer( context, url ).then( function(buf){
            callback( buf );
        });
    }

}
