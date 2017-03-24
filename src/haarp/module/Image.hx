package haarp.module;

import js.Browser.document;
import js.Browser.window;
import js.Promise;
import js.html.CanvasRenderingContext2D;
import js.html.ImageBitmap;

class Image extends Module {

    public var path(default,null) : String;
    public var context(default,null) : CanvasRenderingContext2D;

    var bmp : ImageBitmap;

    public function new( path : String ) {
        super();
        this.path = path;
    }

    public override function init() {
        context = vision.display.getContext2d();
        //context.imageSmoothingEnabled = false;
        return cast load( path );
    }

    override function render() {
        context.save();
        context.scale( vision.display.width / bmp.width, vision.display.height / bmp.height );
        context.drawImage( bmp, 0, 0 );
        context.restore();
    }

    public function load( path : String ) {
        return new Promise( function(resolve,reject) {
            var img = document.createImageElement();
            img.onload = function(){
                window.createImageBitmap( img ).then( function( bmp ) {
                    this.bmp = bmp;
                    resolve( this );
                });
            }
            img.src = 'file://$path';
        } );
        /*
        Fs.readdir( path, function(e,files) {

            if( e != null ) {
                trace(e);
                callback();
            } else {
                var img = document.createImageElement();
                inline function loadImage( i : Int ) {
                    img.src = 'file://$path/'+files[i];
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
            }
        });
        */
    }
}
