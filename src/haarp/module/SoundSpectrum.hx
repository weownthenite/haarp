package haarp.module;

class SoundSpectrum extends Module {

    public var color : String;
    public var lineWidth : Int;

    public function new( color = '#fff', lineWidth = 1 ) {
        super();
        this.color = color;
        this.lineWidth = lineWidth;
    }

    override function render() {

        var data = vision.audio.timeDomainData;
        var width = vision.display.width;
        var height = vision.display.height;
        var ctx = vision.display.getContext2d();

        ctx.save();
        ctx.beginPath();
        ctx.strokeStyle = color;
        ctx.lineWidth = lineWidth;
        var sw = width / data.length;
        var px = 0.0;
        var py : Float;
        for( i in 0...data.length ) {
            py = (data[i] / 128) * height / 2;
            if( i == 0) {
                ctx.moveTo( px, py );
            } else {
                ctx.lineTo( px, py );
            }
            px += sw;
        }
        ctx.lineTo( width, height / 2 );
        ctx.stroke();

        /*
        ctx.beginPath();
        ctx.fillStyle = color;
        ctx.lineWidth = lineWidth;
        var data = vision.audio.frequencyData;
        var sw = Std.int( width / (data.length/2) );
    	for( i in 0...data.length ) {
			ctx.fillRect( i * sw, 0, sw, height - (data[i] / data.length * height) );
		}
        ctx.stroke();
        */

        ctx.restore();
    }
}
