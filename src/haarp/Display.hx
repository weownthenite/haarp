package haarp;

import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageBitmap;
import js.html.Path2D;
import haarp.display.CompositeOperation;

// abstract ?

class Display {

    public var width(get,set) : Int;
    inline function get_width() return canvas.width;
    inline function set_width(v:Int) return canvas.width = v;

    public var height(get,set) : Int;
    inline function get_height() return canvas.height;
    inline function set_height(v:Int) return canvas.height = v;

    public var alpha(get,set) : Float;
    inline function get_alpha() return context.globalAlpha;
    inline function set_alpha(v:Float) return context.globalAlpha = v;

    public var compositeOperation(get,set) : CompositeOperation;
    inline function get_compositeOperation() return context.globalCompositeOperation;
    inline function set_compositeOperation(v:String) return context.globalCompositeOperation = v;

    public var imageSmoothingEnabled(get,set) : Bool;
    inline function get_imageSmoothingEnabled() return context.imageSmoothingEnabled;
    inline function set_imageSmoothingEnabled(v:Bool) return context.imageSmoothingEnabled = v;

    public var autoClear = true;

    var canvas : CanvasElement;
    var context : CanvasRenderingContext2D;
    //var layers : Array<Layer>;

    public function new( canvas : CanvasElement ) {

        this.canvas = canvas;

        context = canvas.getContext2d();
        context.imageSmoothingEnabled = false;
        //untyped context.imageSmoothingQuality = 'low';

        fitCanvas();

        window.addEventListener( 'resize', handleResize, false );
    }

    public inline function getContext2d() : CanvasRenderingContext2D {
        return canvas.getContext2d();
    }

    public inline function clear() {
        context.clearRect( 0, 0, width, height );
    }

    public inline function clip( path : Path2D ) {
        context.clip( path );
    }

    public inline function draw( bmp : ImageBitmap ) {
        context.drawImage( bmp, 0, 0 );
    }

    public function fitCanvas() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    }

    public function dispose() {
        window.removeEventListener( 'resize', handleResize );
    }

    function handleResize(e) {
        fitCanvas();
    }

}
