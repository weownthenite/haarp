package haarp.module;

import js.Browser.document;
import js.Browser.window;
import js.Promise;
import js.html.CanvasRenderingContext2D;

class Text extends Module {

    public var text(default,null) : String;
    public var x(default,null) : Int;
    public var y(default,null) : Int;
    public var font(default,null) : String;
    public var style(default,null) : String;
    public var context(default,null) : CanvasRenderingContext2D;

    public function new( text : String, x = 0, y = 0, font = '20px Noto Sans', style = '#fff' ) {
        super();
        this.text = text;
        this.x = x;
        this.y = y;
        this.font = font;
        this.style = style;
    }

    public override function init() {
        context = vision.display.getContext2d();
        //context.font = font;
        //context.fillStyle = style;
        //context.imageSmoothingEnabled = false;
        return cast super.init();
    }

    override function render() {
        if( text != null && text.length > 0 ) {
            context.save();
            context.font = font;
            context.fillStyle = style;
            context.fillText( text, x, y );
            context.restore();
        }
        /*
        context.save();
        context.scale( vision.display.width / bmp.width, vision.display.height / bmp.height );
        context.drawImage( bmp, 0, 0 );
        context.restore();
        */
    }


}
