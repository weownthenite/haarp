package haarp.module;

import js.html.CanvasRenderingContext2D;
import om.Time.now;

/*
enum StroboMode {
    interval( show : Int, pause : Int );
    sound( db : Int );
}
*/

class Strobo extends Module {

    public var color : String;
    public var showDuration(default,null) : Int;
    public var pauseDuration(default,null) : Int;

    var active : Bool;
    var lastChangeTime : Float;
    var context : CanvasRenderingContext2D;

    public function new( color : String = '#fff', showDuration = 200, pauseDuration = 500 ) {

        super();
        this.color = color;
        this.showDuration = showDuration;
        this.pauseDuration = pauseDuration;

        active = false;
    }

    override function init( ?callback : Void->Void ) {
        context = vision.canvas.getContext2d();
        callback();
    }

    override function start() {
        lastChangeTime = now();
    }

    override function update() {

        var now = now();
        var diff = now - lastChangeTime;

        if( active ) {
            context.fillStyle = color;
            context.fillRect( 0, 0, vision.canvas.width, vision.canvas.height );
            if( diff > showDuration ) {
                active = false;
                lastChangeTime = now;
            }
        } else {
            if( diff > pauseDuration ) {
                active = true;
                context.fillStyle = color;
                context.fillRect( 0, 0, vision.canvas.width, vision.canvas.height );
                lastChangeTime = now;
            }
        }
    }

    /*
    function show() {
        context.fillStyle = color;
        context.fillRect( 0, 0, vision.canvas.width, vision.canvas.height );
        //block = true;
    }
    */
}
