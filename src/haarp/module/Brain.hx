package haarp.module;

import js.Browser.console;
import js.Promise;
import js.html.CanvasRenderingContext2D;
import js.node.Buffer;
import js.npm.SerialPort;

typedef BrainData = {

    /**
        0: Connected
        200: No Signal
    */
    var signal : Int;

    var strength : Int;
    var attention : Int;
    var meditation : Int;
    var delta : Int;
    var theta : Int;
    var low_alpha : Int;
    var high_alpha : Int;
    var low_beta : Int;
    var high_beta : Int;
    var low_gamma : Int;
    var high_gamma : Int;
}

class Brain extends Module {

    public dynamic function onConnect() {}
    public dynamic function onData( data : BrainData ) {}

    var serial : SerialPort;
    var baudrate : BaudRate;
    var input : String;

    public function new( baudrate : BaudRate = 9600 ) {
        super();
        this.baudrate = baudrate;
    }

    override function init() {

        return new Promise( function(resolve,reject) {

            SerialPort.list( function(e,devices) {

    			if( e != null ) reject( e ) else {

    				//for( device in devices ) trace( device );

    				var port = devices[0]; //TODO select proper device
                    serial = new SerialPort( port.comName, {
    					baudrate: baudrate
    				});
                    function handleOpen() {
                        console.log( 'Brain connected' );
                        serial.removeListener( open, handleOpen );
                        resolve( cast this );
                        onConnect();
                    }
    				serial.on( open, handleOpen );
    			}
    		});
        });
    }

    override function start() {
        input = "";
        serial.on( data, handleData );
    }

    override function stop() {
        input = null;
        serial.removeListener( data, handleData );
    }

    override function dispose() {
        if( serial != null ) {
            serial.removeListener( data, handleData );
            serial.close();
        }
    }

    function handleData( buf : Buffer ) {
        var str = buf.toString();
        var lineBreakPos = str.indexOf( '\n' );
        if( lineBreakPos != -1 ) {
            input += str.substr( 0, lineBreakPos );
            var parts = input.split( ',' );
            if( parts.length == 11 ) {
                onData( {
                    signal: Std.parseInt( parts[0] ),
                    strength: Std.parseInt( parts[1] ),
                    attention: Std.parseInt( parts[2] ),
                    meditation: Std.parseInt( parts[3] ),
                    delta: Std.parseInt( parts[4] ),
                    theta: Std.parseInt( parts[5] ),
                    low_alpha: Std.parseInt( parts[6] ),
                    high_alpha: Std.parseInt( parts[7] ),
                    low_beta: Std.parseInt( parts[8] ),
                    high_beta: Std.parseInt( parts[9] ),
                    low_gamma: Std.parseInt( parts[10] ),
                    high_gamma: Std.parseInt( parts[11] ),
                });
                input = "";
            } else {
                //trace("waiting for more data "+lineBreakPos);
                //console.log( input );
                //js.node.Fs.appendFile( 'brain.dump', line+'\n', function(e){} );
                input = str.substring( lineBreakPos + 1 );
            }
        } else {
            input += str;
        }
    }

}
