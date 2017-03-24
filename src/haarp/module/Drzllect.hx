package haarp.module;

import js.Browser.document;
import js.Browser.window;
import js.Promise;
import js.html.VideoElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageBitmap;
import js.Browser.document;
import js.node.Buffer;
import js.node.Fs;

class Drzllect extends Module {

    public var path(default,null) : String;
    public var index : Int;
    //public var changeFactor : Float;

    var images : Array<ImageBitmap>;
    var context : CanvasRenderingContext2D;

    public function new( path : String, enabled = true ) {
        super( enabled );
        this.path = path;
    }

    public override function init() {

        context = vision.display.getContext2d();
        context.imageSmoothingEnabled = false;

        index = 0;
        images = [];

        return cast load( path );
    }

    override function render() {

        var volume = vision.audio.meter.volume;
        /*
        if( volume < 0.003 ) {
            //vision.display.clear();
            return;
        }

        trace(volume);
        */

        /*
        if( volume > 0.04 ) {
            index = Math.floor( Math.random() * images.length );
		//	context.fillStyle = '#fff000';
            //return;
			//context.fillRect( 0, 0, vision.display.width, vision.display.height );
		}
        */

        /*
        //index = images.length - Std.int( images.length / (volume * 100) );
        index = images.length - Std.int( images.length / (volume * 100) );
        if( index >= images.length ) index = images.length-1;
        else if( index < 0) index = 0;

        //trace(volume,index);
        //index = Math.floor( volume * images.length*100 );
        */

        var img = images[index];

        context.save();
        context.scale( vision.display.width / img.width, vision.display.height / img.width );
        context.drawImage( img, 0, 0 );
        context.restore();

        index++;
        if( index >= images.length ) index = 0;
    }

    public function load( path : String ) : Promise<Drzllect> {

        return new Promise( function(resolve,reject) {

            Fs.readdir( path, function(e,files) {

                if( e != null ) reject( e ) else {

                    var img = document.createImageElement();
                    inline function loadImage( i : Int ) {
                        img.src = 'file://$path/' + files[i];
                    }
                    img.onload = function(){
                        //if( sys.FileSystem.exists( '$path/.meta/'+files[i] ) ) {
                        window.createImageBitmap( img ).then( function( bmp ) {
                            images.push( bmp );
                            if( images.length == files.length ) {
                                resolve( this );
                            } else {
                                loadImage( images.length );
                            }
                        });
                    }
                    loadImage( 0 );
                }
            });
        });
    }
}
