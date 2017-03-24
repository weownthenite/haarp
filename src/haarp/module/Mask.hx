package haarp.module;

import js.Browser.document;
import js.Browser.window;
import js.Promise;
import js.html.CanvasRenderingContext2D;
import js.html.ImageBitmap;

class Mask extends Module {

    var context : CanvasRenderingContext2D;

    public function new() {
        super();
    }

    public override function init() {
        context = vision.display.getContext2d();
        return cast super.init();
    }

    override function render() {

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

        /*
        context.save();
        context.scale( vision.display.width / bmp.width, vision.display.height / bmp.height );
        context.drawImage( bmp, 0, 0 );
        context.restore();
        */
    }

}
