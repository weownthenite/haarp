package haarp;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.audio.AudioContext;

class Vision {

    public var name(default,null) : String;
    public var started(default,null) : Bool;
    public var sound(default,null) : Sound;
    public var display(default,null) : Display;

    var modules : Array<Module>;

    public function new() {
        started = false;
        sound = new Sound();
        display = new Display( window.innerWidth, window.innerHeight );
        modules = [];
    }

    public function init( modules : Array<Module>, callback : Void->Void ) {
        if( modules.length == 0 ) callback() else {
            var i = 0;
            var loadModule : Void->Void;
            loadModule = function() {
                var mod = modules[i];
                console.group( i+':'+mod.name );
                mod.vision = this;
                mod.init( function() {
                    console.groupEnd();
                    if( ++i == modules.length ) {
                        this.modules = modules;
                        callback();
                    } else {
                        loadModule();
                    }
                });
            }
            loadModule();
        }
    }

    public function start() {
        started = true;
        for( mod in modules ) mod.start();
    }

    public function update() {
        sound.update();
        for( mod in modules ) {
            if( mod.enabled ) {
                mod.update();
            }
        }
    }

    public function render() {
        display.clear();
        for( mod in modules ) {
            if( mod.enabled ) {
                mod.render();
            }
        }
    }

    public function stop() {
        started = false;
        display.clear();
        for( mod in modules ) mod.stop();
    }

    /*
    public function draw( bmp : js.html.ImageBitmap ) {
    }
    */

    public function serialize() {
        return {
            name: name
        }
    }

}
