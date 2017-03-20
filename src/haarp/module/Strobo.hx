package haarp.module;

import js.html.CanvasRenderingContext2D;
import om.Time.now;

/*
enum StroboMode {
    interval( show : Int, pause : Int );
    sound( db : Int );
}
*/

class Strobo extends AbstractModule {

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
        context = vision.display.getContext2d();
        callback();
    }

    override function start() {
        lastChangeTime = now();
    }

    override function render() {

        var now = now();
        var diff = now - lastChangeTime;

        if( active ) {
            if( diff > showDuration ) {
                active = false;
                lastChangeTime = now;
            } else {
                draw();
            }
        } else {
            if( diff > pauseDuration ) {
                active = true;
                draw();
                lastChangeTime = now;
            }
        }
    }

    function draw() {
        context.fillStyle = color;
        context.fillRect( 0, 0, vision.display.width, vision.display.height );
    }

}
