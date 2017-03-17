package haarp.module;

import js.html.CanvasRenderingContext2D;
import om.Time;

class TestModule extends Module {

    static var COLORS = ['#ff0000','#99ff00','#0000ff'];

    var context : CanvasRenderingContext2D;
    var interval : Int;
    var index : Int;
    var lastChangeTime : Float;
    var changesTotal : Int;

    public function new( interval = 1000 ) {
        super();
        this.interval = interval;
    }

    override function init( ?callback : Void->Void ) {
        context = vision.display.canvas.getContext2d();
        callback();
    }

    override function start() {
        index = changesTotal = 0;
        lastChangeTime = Time.now();
    }

    override function update() {
        var now = Time.now();
        var diff = now - lastChangeTime;
        if( diff > interval ) {
            if( ++index == COLORS.length ) index = 0;
            lastChangeTime = now;
            changesTotal++;
        }
    }

    override function render() {

        context.fillStyle = COLORS[index];
        context.fillRect( 0, 0, vision.display.width, vision.display.height );

        context.fillStyle = '#fff';
        context.font = '48px serif';
        context.fillText( Std.string( changesTotal ), 10, 100 );
    }

}
