package haarp.app;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;

import haarp.module.*;

class VisionActivity extends om.Activity {

    var vision : Vision;
    var animationFrameId : Int;

    public function new( vision : Vision ) {

        super();
        this.vision = vision;

        #if !debug
        element.style.cursor = 'none';
        #end
    }

    override function onCreate() {
        super.onCreate();
        element.appendChild( vision.canvas );
    }

    override function onStart() {

        super.onStart();

        console.group( 'start' );

        vision.start();

        animationFrameId = window.requestAnimationFrame( update );
    }

    override function onStop() {

        super.onStop();

        vision.stop();

        console.group( 'stop' );
        console.groupEnd();

        window.cancelAnimationFrame( animationFrameId );
        animationFrameId = null;
    }

    function update( time : Float ) {

        animationFrameId = window.requestAnimationFrame( update );
        vision.update();

        //trace(time);
    }

}
