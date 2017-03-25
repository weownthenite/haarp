package haarp;

import js.Promise;
import js.html.Uint8Array;
import js.html.audio.AudioContext;
import js.html.audio.AudioBuffer;
import js.html.audio.AudioBufferSourceNode;
import js.html.audio.AnalyserNode;
import js.html.audio.GainNode;
import om.audio.AudioBufferLoader;
import om.audio.VolumeMeter;

class Audio {

    public var context(default,null) : AudioContext;
    public var meter(default,null) : VolumeMeter;
    public var frequencyData(default,null) : Uint8Array;
    public var timeDomainData(default,null) : Uint8Array;

    public var volume(get,set) : Float;
    inline function get_volume() return gain.gain.value;
    inline function set_volume(v) return gain.gain.value = v;

    var gain : GainNode;
    var analyser : AnalyserNode;

    public function new( volume = 1.0 ) {

        context = new AudioContext();

        gain = context.createGain();
		gain.gain.value = volume;

        analyser = context.createAnalyser();
		analyser.fftSize = 2048;
        frequencyData = new Uint8Array( analyser.frequencyBinCount );
		timeDomainData = new Uint8Array( analyser.frequencyBinCount );

        meter = new VolumeMeter( context, 512, 0.98, 0.95, 750 );

        gain.connect( analyser );
        analyser.connect( meter.processor );
        analyser.connect( context.destination );
    }

    public inline function load( url : String ) : Promise<AudioBuffer> {
        return AudioBufferLoader.loadAudioBuffer( context, url );
    }

    public inline function connect( node : AudioBufferSourceNode ) {
        node.connect( gain );
    }

    public function update() {
        analyser.getByteFrequencyData( frequencyData );
        analyser.getByteTimeDomainData( timeDomainData );
    }

    /*
    public function mute() {
        gain.gain.value = 0;
    }

    public function unmute() {
        gain.gain.value = 0;
    }
    */
}
