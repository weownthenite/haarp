package haarp.module;

import js.Browser.console;
import js.Promise;
import js.html.Path2D;
import js.node.Fs;

/**
    2D mask.
**/
class Mask extends Module {

    public var path : Path2D;

    public function new( ?path : Path2D ) {
        super();
        this.path = (path == null) ? new Path2D() : path;
    }

    override function render() {
        if( path != null ) {
            //vision.display.compositeOperation = 'destination-lighter';
            ///vision.display.clip( path );
        }
    }

    /*
    public function loadSVG( path : String ) {
        return new Promise( function(resolve,reject){
            Fs.readFile( path, function(e,buf){
                if( e != null ) reject(e) else {
                    //trace(buf.toString());
                    //var str = buf.toString();
                    var svg = new js.html.DOMParser().parseFromString( buf.toString(), IMAGE_SVG_XML );
                    //TODO
                    //trace( svg.children[0].children[0] );
                    resolve( cast this );
                }
            });
        });
    }
    */

}
