package haarp;

import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.MediaStream;

class Display {

    public var canvas(default,null) : CanvasElement;

    public var width(get,set) : Int;
    inline function get_width() return canvas.width;
    inline function set_width(v:Int) return canvas.width = v;

    public var height(get,set) : Int;
    inline function get_height() return canvas.height;
    inline function set_height(v:Int) return canvas.height = v;

    public var backgroundColor(default,null) : String;
    inline function get_backgroundColor() return canvas.style.backgroundColor;
    inline function set_backgroundColor(v:String) return canvas.style.backgroundColor = v;

    var context : CanvasRenderingContext2D;

    public function new( width : Int, height : Int ) {

        canvas = document.createCanvasElement();
        canvas.width = width;
        canvas.height = height;

        context = canvas.getContext2d();
    }

    public inline function getContext2d() : CanvasRenderingContext2D {
        return canvas.getContext2d();
    }

    public inline function captureStream() : MediaStream {
        return untyped canvas.captureStream();
    }

    public inline function setSize( width : Int, height : Int ) {
        canvas.width = width;
        canvas.height = height;
    }

    public inline function clear() {
        context.clearRect( 0, 0, canvas.width, canvas.height );
    }

}
