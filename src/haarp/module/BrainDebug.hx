package haarp.module;

import js.Browser.console;
import haarp.module.Brain;

class BrainDebug extends Module {

    var data : Array<BrainData>;
    var maxData : Int;

    public function new( maxData = 1000 ) {
        super();
        this.maxData = maxData;
    }

    override function start() {
        data = [];
    }

    override function stop() {
        data = null;
    }

    override function render() {

        function draw( name : String, color : String ) {
            var v = createData( name );
            drawWave( v.values, v.max, color );
        }
        //draw( 'delta', '#0000ff' );
        //draw( 'theta', '#F44336' );
        draw( 'attention', '#03A9F4' );
        draw( 'meditation', '#FF9100' );

        //var v = createData( 'signal' );
        //trace( v );
        /*
        var meditation = createData( 'meditation' );
        trace(  meditation);
        drawWave( meditation.values, meditation.max, '#fff000' );
        */
    }

    public function addData( data : BrainData ) {
        //trace(data.meditation);
        this.data.push( data );
        if( this.data.length == maxData ) this.data.shift();
    }

    function createData( name : String ) : { values : Array<Int>, max : Int } {
        var values = new Array<Int>();
        var max = 0;
        for( msg in data ) {
            var v = Reflect.field( msg, name );
            if( v > max ) max = v;
            //attention.push( msg.attention );
            //if( msg.meditation != null && msg.meditation > meditationMax )
            //    meditationMax = msg.meditation;
            values.push( v );
        }
        return { values: values, max: max };
    }

    function drawWave( data : Array<Int>, maxValue : Int, color : String ) {
        var sw = vision.display.width / data.length;
        var ctx = vision.display.getContext2d();
        ctx.save();
        ctx.strokeStyle = color;
        ctx.beginPath();
        ctx.moveTo( 0, 0 );
    	for( i in 0...data.length ) {
            var value = data[i];
            if( value == null ) value = 0;
            var percent = value / maxValue * 100;
            ctx.lineTo( i * sw, vision.display.height - (vision.display.height / 100 * percent) );
        }
    	ctx.stroke();
        ctx.restore();
    }

}
