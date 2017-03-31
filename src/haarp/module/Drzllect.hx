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
import om.Random;

class Drzllect extends Module {

    //public var mode : Int;

    public var path(default,null) : String;
    public var index(default,null) : Int;
    public var changeFactor(default,null) = 1.0;
    //public var usedChangeFactor(default,null) : Float;
    //public var imageChangeFactor = 1.0;
    //public var randomOffsetFactor = 20;

    //public var changeFactor : Float;

    var images : Array<ImageBitmap>;
    var context : CanvasRenderingContext2D;

    var lastVolume : Float;

    public function new( path : String, enabled = true ) {
        super( enabled );
        this.path = path;
        //changeFactor = 0;
        lastVolume = 0;
    }

    public override function init() {

        context = vision.display.getContext2d();
        context.imageSmoothingEnabled = false;

        index = 0;
        images = [];

        return cast load( path );
    }

    /*
    override function update( time : Float ) {
        //if( changeFactor > 1 ) changeFactor = 1;
        //else if( changeFactor < 0 ) changeFactor = 0;
    }
    */

    override function update( time : Float ) {

        var vol = vision.audio.meter.volume;


        if( vol < 0.003 ) {
            //vision.display.clear();
            return;
        //} else if( vol > 0.99 ) {
        //    vision.display.clear();
        //    return;
        }

        var volDiff = vol - lastVolume;
        lastVolume = vol;

        //trace( volDiff );
        //trace( vol );

        index = (images.length-1) - Std.int( vol * (images.length-1) );
        index += Std.int( volDiff );
        //trace(Std.int( changeFactor * 100 ));
        // - Std.int( volDiff * (images.length-1) );
        //index = (images.length-1) - Std.int( volDiff * (images.length-1) );
        //index = Std.int( Math.random() * (images.length-1) );
    //    index += Std.int( volDiff * 1000 );

        //var changeFactorValue = Std.int( changeFactor * 100 );
        //index += changeFactorValue;
        //trace(changeFactorValue);

        if( index >= 1000 ) {
            index = 999 - Std.int( Math.random()*10 );
        } else if( index < 0 ) {
            index = Std.int( Math.random()*10 );
        }

        //index = images.length - Std.int( vol * (images.length-1) );

        /*
        //usedChangeFactor = changeFactor;
        var change = Random.bool( 1 - changeFactor );
        //trace(changeFactor, change);

        if( change ) {

            // Get image by volume
            index = images.length - Std.int( vol * images.length );

            // A bit more random anyhow
        //    var randomOffsetFactor = Std.int( vol * 100 );
        //    index = index - randomOffsetFactor + Std.int( Math.random() * (randomOffsetFactor*2) );

            //if( index < 0 ) index = 0;
            //else if( index > images.length ) index = images.length - 1;

        } else {

        }
        */
    }

    override function render() {

        var img = images[index];
        context.save();
        context.scale( vision.display.width / img.width, vision.display.height / img.width );
        context.drawImage( img, 0, 0 );
        context.restore();

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

        //index++;
        //if( index >= images.length ) index = 0;
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
