package haarp;

import haxe.Json;
import js.Browser.console;
import js.Browser.document;
import js.Browser.navigator;
import js.Browser.window;
import om.Time;

class App implements om.App {

    public static inline var RES = '/home/tong/dev/HAARP';
    public static inline var WEB = 'http://localhost/HAARP';

    static var vision : Vision;
    static var startTime : Float;

    static function update( time : Float ) {

        window.requestAnimationFrame( update );

        var time = (Time.now() - startTime) / 1000;
        vision.update( time );
        vision.render();
    }

    static function toggleFullScreen() {
        if( untyped document.webkitFullscreenElement == null )
            untyped document.body.webkitRequestFullscreen();
        else
            untyped document.webkitExitFullscreen();
    }

    static function init() {

        var name = window.location.search.substr( 1 );
        console.info( name);

        #if HEAD1B
        vision = new haarp.vision.HEAD1B( '$RES/video/danzig' );
        #else
        vision = new haarp.vision.HEAD1A();
        #end

        vision.init().then( function(e){

            haxe.Timer.delay( function(){

                console.log( 'start' );
                window.requestAnimationFrame( update );
                startTime = Time.now();
                vision.start();

            }, 200 );

            document.body.onmousedown  = function(e) {
                switch e.which {
                case 1:
                case 3: toggleFullScreen();
                }
            }

        }).catchError( function(e) {
            console.error( e );
            return;
        });
    }
}
