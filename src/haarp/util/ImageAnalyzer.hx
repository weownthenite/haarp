package haarp.util;

#if nodejs
import js.Error;
import js.node.Buffer;
import js.node.ChildProcess;
import js.node.child_process.ChildProcess as Process;
import js.node.child_process.ChildProcess.ChildProcessEvent;
import js.node.stream.Readable;
#end

using StringTools;

class ImageAnalyzer {

    public static function calculateBrightness( rgb : Array<Int> ) {
        return ((rgb[0] & 0xFF) << 16) | ((rgb[1] & 0xFF) << 8) | ((rgb[2] & 0xFF) << 0);
    }

    #if nodejs

    public static function getAverageColors( path : String, callback : Error->Array<Int>->Void ) {
        var result : Buffer;
        var error : Error;
        var process = ChildProcess.spawn( 'convert', [path,'-resize','1x1!','-format','"%[fx:int(255*r+.5)],%[fx:int(255*g+.5)],%[fx:int(255*b+.5)]"','info:'] );
        process.on( ChildProcessEvent.Exit, function(code,m){
            switch code {
            case 0: //callback( null, result );
            case _: //callback( error, null );
            }
        } );
		process.stderr.on( ReadableEvent.Data, function(e){
            trace(e);
        } );
		process.stdout.on( ReadableEvent.Data, function(buf:Buffer) {
            //result = buf;
            var str = buf.toString().substr(1);
            str = str.substr( 0, str.length-1 );
            var parts = str.split( ',' );
            //var rgb = [for( part in parts ) Std.parseInt( part ) ];
            //var r = Std.parseInt( parts[0] );
            //var g = Std.parseInt( parts[1] );
            //var b = Std.parseInt( parts[2] );
            callback( null, [for( part in parts ) Std.parseInt( part ) ] );
            //var brightness = ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | ((b & 0xFF) << 0);
            //trace( r,g,b );
            //trace( brightness );
			//trace( '%c'+buf.toString(), 'color:#F68712;' );
        });
    }

    #elseif sys

    //TODO
    
    #end

}
