package haarp.module;

import js.Browser.document;
import js.Browser.window;
import js.Promise;
import js.html.CanvasRenderingContext2D;
import js.html.Path2D;

/**
    2D mask.
**/
class Mask extends Module {

    public var path : Path2D;

    var context : CanvasRenderingContext2D;

    public function new( path : Path2D ) {
        super();
        this.path = path;
    }

    /*
    override function init() {
        return cast super.init().then( function(_){
            context = vision.display.getContext2d();
        });
    }
    */

    override function render() {

        if( path != null ) {
            vision.display.clip( path );
        }

        /*
        //context.save();

        //context.globalCompositeOperation = 'lighter';

        var w = vision.display.width;
        var h = vision.display.height;
        var c = 200;

        context.beginPath();

        context.arc( c, c, c, Math.PI, 0, false );
        context.arc( w-c, c, c, Math.PI, 0, false );

        context.moveTo( c, 0 );
        context.lineTo( w - c, 0 );
        context.lineTo( w - c, c );
        context.lineTo( c, h );

        context.moveTo( 0, c );
        context.lineTo( w, c );
        context.lineTo( w, h );
        context.lineTo( 0, h );

        context.closePath();

        context.clip();

        //context.restore();
        */
    }
}
