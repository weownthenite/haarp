package haarp;

import haxe.Json;
import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import js.html.VideoElement;
import js.html.audio.AudioContext;
import js.html.audio.BiquadFilterType;
import js.html.audio.OfflineAudioContext;
import om.audio.AudioBufferLoader;
import om.audio.BeatDetection;
import electron.renderer.IpcRenderer;

class Render implements om.App {

	static inline var RESOURCE = 'http://localhost/HAARP';

	//static inline var WIDTH = 1280;
	//static inline var HEIGHT = 720;
	//static var videos : Array<VideoElement>;

	static function update( time : Float ) {
		window.requestAnimationFrame( update );
	}

	static function handleMessage(e,arg) {
        trace(e);
        trace(arg);
        //trace(data);
        //trace(data.test);
    }

    static function init() {

		//IpcRenderer.sendSync( 'synchronous-message', 'ping' );
		IpcRenderer.on( 'asynchronous-reply', function(e,a){
		//	trace( e );
			trace( a );
		} );

		IpcRenderer.send( 'asynchronous-message', 'boot' );

		trace("...");
		// TODO load set

    }

    static function main() {

		trace( 'HAARP Render' );

		window.onload = function() {
			init();
		}
	}
}
