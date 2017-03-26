package haarp.module;

import js.Browser.window;
import js.Promise;
import js.html.CanvasRenderingContext2D;
import js.html.ImageData;
import js.html.ImageBitmap;
import js.html.Uint8ClampedArray;
import om.Time.now;

class Pixelate extends Module {

    public var value : Int;
    public var mix : Float;

    public function new( value = 10, mix = 1.0 ) {
        super();
        this.value = value;
        this.mix = mix;
    }

    override function render() {
        pixelate( vision.display.getContext2d().getImageData( 0, 0, vision.display.width, vision.display.height ), value, mix );
    }

    function pixelate( data : ImageData, size : Int, mix : Float ) {
        var ctx = vision.display.getContext2d();
        var x = 0;
        while( x < vision.display.width ) {
            var y = 0;
            while( y < vision.display.height ) {
                var pixels = ctx.getImageData( x, y, size, size );
                var rgb = getAverageRGB( pixels.data );
                ctx.save();
                ctx.fillStyle = 'rgba(${rgb.r},${rgb.g},${rgb.b},$mix)';
                ctx.fillRect( x, y, size, size );
                ctx.restore();
                y += size;
            }
            x += size;
        }
    }

    static function getAverageRGB( data : Uint8ClampedArray ) {
        var r = 0;
        var g = 0;
        var b = 0;
        var total = 0;
        var i = 0;
        while( i < data.length ) {
            if( data[i+3] != 0 ) {
                r += data[i+0];
                g += data[i+1];
                b += data[i+2];
                total++;
            }
            i += 4;
        }
        return {
            r: Math.floor( r / total ),
            g: Math.floor( g / total ),
            b: Math.floor( b / total )
        };
    }

}
