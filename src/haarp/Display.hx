package haarp;

import js.Browser.document;
import js.Browser.window;
import js.html.ImageBitmap;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;

/*
private class Layer {

    public var visible : Bool;
    public var alpha : Float;

    public function new() {
        visible = true;
    }

    public function draw( bmp : ImageBitmap ) {
    }
}
*/

@:enum abstract CompositeOperation(String) from String to String {
    var source_over = 'souce-over';
    var source_in = 'souce-in';
    var source_out = 'souce-out';
    var source_atop = 'souce-atop';
    var destination_over = 'destination-over';
    var destination_in = 'destination-in';
    var destination_out = 'destination-out';
    var destination_atop = 'destination-atop';
    var destination_lighter = 'destination-lighter';
    var copy = 'copy';
    var xor = 'xor';
    var multiply = 'multiply';
    var screen = 'multiply';
    var overlay = 'overlay';
    var lighten = 'lighten';
    var color_dodge = 'color-dodge';
    var color_burn = 'color-burn';
    var hard_light = 'hard-light';
    var soft_light = 'soft-light';
    var difference = 'difference';
    var exclusion = 'exclusion';
    var hue = 'hue';
    var saturation = 'saturation';
    var color = 'color';
    var luminosity = 'luminosity';
}

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

    var canvas : CanvasElement;
    var context : CanvasRenderingContext2D;
    //var layers : Array<Layer>;

    public function new( canvas : CanvasElement ) {

        this.canvas = canvas;

        context = canvas.getContext2d();
        context.imageSmoothingEnabled = false;

        window.addEventListener( 'resize', handleResize, false );
    }

    public inline function getContext2d() : CanvasRenderingContext2D {
        return canvas.getContext2d();
    }

    public inline function clear() {
        context.clearRect( 0, 0, width, height );
    }

    public inline function draw( bmp : ImageBitmap ) {
        context.drawImage( bmp, 0, 0 );
    }

    public function dispose() {
        window.removeEventListener( 'resize', handleResize );
    }

    function handleResize(e) {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    }

}
