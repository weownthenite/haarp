package haarp.app;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.KeyboardEvent;

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
        element.appendChild( vision.display.canvas );
    }

    override function onStart() {

        super.onStart();

        console.group( 'start' );

        startVision();

        animationFrameId = window.requestAnimationFrame( update );

        window.addEventListener( 'resize', handleWindowResize, false );
        window.addEventListener( 'keydown', handleKeyDown, false );
    }

    override function onStop() {

        super.onStop();

        console.groupEnd( 'stop' );

        stopVision();

        window.cancelAnimationFrame( animationFrameId );
        animationFrameId = null;

        window.removeEventListener( 'resize', handleWindowResize );
        window.removeEventListener( 'keydown', handleKeyDown );
    }

    function startVision() {
        trace("startVision");
        //animationFrameId = window.requestAnimationFrame( update );
        vision.start();
    }

    function stopVision() {
        trace("stopVision");
        //window.cancelAnimationFrame( animationFrameId );
        //animationFrameId = null;
        vision.stop();
    }

    function update( time : Float ) {

        animationFrameId = window.requestAnimationFrame( update );

        /*
        var gamepads = js.Browser.navigator.getGamepads();
        for( gamepad in gamepads ) {
            if( gamepad != null ) {
                /*
                if( gamepad.buttons[0].pressed ) {
                    vision.started ? stopVision() : startVision();
                }
            }
        }
        */

        if( vision.started ) {
            vision.update();
            vision.render();
        }
    }

    function handleWindowResize(e) {
        vision.display.setSize( window.innerWidth, window.innerHeight );
    }

    function handleKeyDown( e : KeyboardEvent ) {
        //trace(e.keyCode);
        switch e.keyCode {
        case 13:
        case 32:
            vision.started ? stopVision() : startVision();
        }
    }

}
