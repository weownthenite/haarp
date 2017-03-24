
import Sys.println;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

using StringTools;

class Run {

    static function exit( ?info : String, code = 0 ) {
        if( info != null ) println( info );
        Sys.exit(0);
    }

    static function sortByBrightness( src : String, dst : String ) {

        var files = FileSystem.readDirectory( src );
        var colors = new Array<Array<Int>>();
        var brightnesses = new Array<Int>();
		var nstart = 0;
		//var n = 3600;

        for( i in 0...files.length ) {
			var file = files[i];
            var path = '$src/$file';
            var identify = new Process( 'convert', [path,'-resize','1x1!','-format','"%[fx:int(255*r+.5)],%[fx:int(255*g+.5)],%[fx:int(255*b+.5)]"','info:'] );
            //var result = identify.stdout.readAll();
            var error = identify.stderr.readAll().toString();
            if( error != "" ) {
                println( error.toString() );
                Sys.exit(1);
            } else {

                var result = identify.stdout.readAll();
                var val = result.toString().trim();
                var val = val.substr( 1 );
                val = val.substr( 0, val.indexOf( '"' ) );
                var parts = val.split( ',' );

                var rgb = [for(c in parts) Std.parseInt(c)];
                colors.push( rgb );

                var brightness = ((rgb[0] & 0xFF) << 16) | ((rgb[1] & 0xFF) << 8) | ((rgb[2] & 0xFF) << 0);
				brightnesses.push( brightness );

                println( rgb+':'+brightness );
            }
        }

        var sortedPaths = new Array<String>();
        var sortedBrightnesses = new Array<Int>();

        for( i in 0...files.length ) {
            if( i == 0 ) {
                sortedPaths.push( files[0] );
                sortedBrightnesses.push( brightnesses[0] );
            } else {
                var f1 = files[i];
                var v1 = brightnesses[i];
                var inserted = false;
                for( j in 0...sortedBrightnesses.length ) {
                    var v2 = sortedBrightnesses[j];
                    if( v1 > v2 ) {
                        sortedPaths.insert( j, f1 );
                        sortedBrightnesses.insert( j, v1 );
                        inserted = true;
                        break;
                    }
                }
                if( !inserted ) {
                    sortedPaths.push( f1 );
                    sortedBrightnesses.push( v1 );
                }
            }
        }

        if( !FileSystem.exists( dst ) ) FileSystem.createDirectory( dst );

		for( i in 0...sortedPaths.length ) {
            var dstPath = '$dst/$i-'+sortedBrightnesses[i]+'.jpg';
            //println( i+": "+dstPath );
			File.copy( '$src/'+sortedPaths[i], dstPath );
		}

    }

    static function main() {

        var args = Sys.args();

        switch args[0] {

        case 'sort':

            var path = args[1];
            if( path == null ) exit( 'Missing path to image directory', -1 );
            if( !FileSystem.exists( path ) ) exit( 'Not found', -1 );
            if( !FileSystem.isDirectory( path ) ) exit( 'Not a directory', -1 );

            sortByBrightness( path, path + '_sorted' );
            /*
            trace( FileSystem.readDirectory(path) );
            for( f in FileSystem.readDirectory( path ) ) {
                var filepath = '$path/f';

            }
            */
        }
    }
}
