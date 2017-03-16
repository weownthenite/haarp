package haarp.module;

import js.Browser.document;
import js.Browser.window;
import js.html.ImageBitmap;
import js.html.ImageElement;
import js.html.CanvasRenderingContext2D;
import js.node.Buffer;
import js.node.Fs;
import haxe.crypto.Base64;

class Drzllect extends Module {

    var path : String;
    var images : Array<ImageBitmap>;
    //var images : Array<ImageElement>;
    var ctx : CanvasRenderingContext2D;
    var index = 0;

    public function new( path : String ) {
        super();
        this.path = path;
        images = [];
    }

    override function init( ?callback : Void->Void ) {

        super.init();

        ctx = vision.canvas.getContext2d();
        ctx.imageSmoothingEnabled = false;

        Fs.readdir( path, function(e,files) {

            if( e != null ) {
                trace(e);
                callback();
            } else {
                /*
                for( i in 0...files.length ) {
                    trace(">>"+i);
                    var img = document.createImageElement();
                    img.src = 'file://$path/'+files[i];
                    img.onload = function() {
                        window.createImageBitmap( img ).then( function( bmp ) {
                            images.push( bmp );
                            trace("ok "+images.length);
                            if( images.length == files.length ) {
                                callback();
                            }
                        });
                    }
                }
                */

                var img = document.createImageElement();
                inline function loadImage( i : Int ) {
                    img.src = 'file://$path/'+files[i];
                    //img.src = 'http://localhost/HAARP/image/archillect/'+files[i];
                }
                img.onload = function(){
                    window.createImageBitmap( img ).then( function( bmp ) {
                        images.push( bmp );
                        if( images.length == files.length ) {
                            callback();
                        } else {
                            loadImage( images.length );
                        }
                    });
                }
                loadImage( 0 );
                //img.src = 'data:image/jpg;base64,'+b.toString( 'base64' );
            }
        } );
    }

    override function update() {

        if( !enabled )
            return;

        var img = images[index];

        ctx.save();
        ctx.scale( vision.canvas.width / img.width, vision.canvas.height / img.height );
        ctx.drawImage( images[index], 0, 0 );
        ctx.restore();

        if( ++index == images.length ) index = 0;
    }

    override function dispose() {
        for( img in images ) {
            //img.close();
        }
    }
}
