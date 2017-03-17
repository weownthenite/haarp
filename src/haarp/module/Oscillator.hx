package haarp.module;

import js.html.CanvasRenderingContext2D;

class Oscillator extends Module {

    public var color : String;

    var context : CanvasRenderingContext2D;

    public function new( color = '#fff', lineWidth = 1 ) {
        super();
        this.color = color;
    }

    override function init( ?callback : Void->Void ) {
        context = vision.display.canvas.getContext2d();
        //context.strokeStyle = '#fff';
        //context.fillStyle = '#fff';
        callback();
    }

    override function render() {

        var canvas = vision.display.canvas;
        var w = canvas.width;
        var h = canvas.height;

        context.lineWidth = 1;
        context.strokeStyle = color;
        //context.fillStyle = '#fff';

        var data = vision.sound.timeDomainData;
        var sw = canvas.width * 1 / data.length;
        var px = 0.0;
        var py : Float;
        context.beginPath();
        for( i in 0...data.length ) {
            py = (data[i] / 128.0) * h/2;
            //var py = data[i] * canvas.height / 2 + (canvas.height/2);
            if( i == 0) {
                context.moveTo( px, py );
            } else {
                context.lineTo( px, py );
            }
            px += sw;
        }
        context.lineTo( canvas.width, canvas.height/2 );
        context.stroke();

        /*
        var data = vision.sound.frequencyData;
        var sw = Std.int( w / (data.length/2) );
    	for( i in 0...data.length ) {
			context.fillRect( i*sw, 0, sw, data[i] / 256 * h );
		}
        context.stroke();
        */
    }


}
