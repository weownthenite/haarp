package haarp;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;

class App implements om.App {

    public static inline var RES = '/home/tong/dev/HAARP';
    public static inline var WEB = 'http://localhost/HAARP';

    public static var ip(default,null) : String;

    static var animationFrameId : Int;
    static var vision : Vision;

    static function update( time : Float ) {
        animationFrameId = window.requestAnimationFrame( update );
        vision.update();
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

        ip = om.Network.getLocalIP()[0];
        console.log( 'IP: $ip' );

        #if HEAD1B
        vision = new haarp.vision.HEAD1B( '$RES/video/danzig' );
        #else
        vision = new haarp.vision.HEAD1A();
        #end

        vision.init().then( function(_) {

            trace( 'Vision Ready' );

            animationFrameId = window.requestAnimationFrame( update );

            vision.onDispose = function() {
                console.info( 'Vision End' );
                window.cancelAnimationFrame( animationFrameId );
            }
            //vision.start();

            document.body.onmousedown  = function(e) {
                switch e.which {
                case 1:
                case 3: toggleFullScreen();
                }
            }

        }).catchError( function(e) {
            console.error( e );
            document.body.style.background = '#FF1744';
            return;
        });
    }
}
