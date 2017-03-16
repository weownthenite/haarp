package haarp;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.audio.AudioContext;

/*
private class Display {

    public var canvas(default,null) : CanvasElement;

    public function new( width : Int, height : Int ) {

        canvas = document.createCanvasElement();
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    }
}
*/

class Vision {

    public var name(default,null) : String;

    public var sound(default,null) : Sound;
    public var canvas(default,null) : CanvasElement;
    //public var display(default,null) : Display;

    var context : CanvasRenderingContext2D;
    var modules : Array<Module>;

    public function new( name : String ) {

        this.name = name;

        //audio = new AudioContext();
        sound = new Sound();

        //display = new Display( window.innerWidth, window.innerHeight );

        canvas = document.createCanvasElement();
        //canvas.classList.add( 'mirror' );
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;

        context = canvas.getContext2d();

        modules = [];
    }

    public function start() {
        for( mod in modules ) mod.start();
    }

    public function update() {

        sound.update();
        
        //trace(audio.currentTime,om.Time.now());
        //trace(untyped window.performance.getEntries());

        context.clearRect( 0, 0, canvas.width, canvas.height );

        for( mod in modules ) {
            if( mod.enabled ) {
                mod.update();
            }
        }
    }

    public function stop() {
        for( mod in modules ) mod.stop();
    }

    /*
    public function draw( bmp : js.html.ImageBitmap ) {
    }
    */

    public static function init( name : String, modules : Array<Module>, callback : Vision->Void ) {

        var vision = new Vision( name );

        var i = 0;
        var loadModule : Void->Void;
        loadModule = function() {
            var mod = modules[i];
            console.group( i+':'+mod.name );
            mod.vision = vision;
            mod.init( function() {
                console.groupEnd();
                if( ++i == modules.length ) {
                    vision.modules = modules;
                    callback( vision );
                } else {
                    loadModule();
                }
            });
        }
        loadModule();
    }

}
