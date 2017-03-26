package haarp.module;

import js.Promise;
import js.html.VideoElement;
import js.html.CanvasRenderingContext2D;
import js.Browser.document;

class Video extends DisplayModule {

    public dynamic function onEnd() {}

    public var path(default,null) : String;

    public var playbackRate(get,set) : Float;
    inline function get_playbackRate() return video.playbackRate;
    inline function set_playbackRate(v:Float) return video.playbackRate = v;

    //public var time(default,null) : Float;
    //inline function get_playbackRate() return video.playbackRate;
    //inline function set_playbackRate(v:Float) return video.playbackRate = v;

    var video : VideoElement;

    public function new( ?path : String, enabled = true ) {
        super( enabled );
        this.path = path;
    }

    override function init() {

        //super.init();

        return new Promise( function(resolve,reject){

            //context = vision.display.getContext2d();
            //context.imageSmoothingEnabled = false;

            video = document.createVideoElement();
            video.muted = true;
            video.loop = true;
            //video.autoplay = true;
            video.onerror = function(e) reject( e );
            video.addEventListener( 'ended', function(e) {
                trace(e);
                onEnd();
            } );

            if( path == null ) {
                resolve( null );
            } else {
                load( path ).then( function(_){
                    resolve( cast this );
                });
            }
        });
    }

    override function start() {
        //video.currentTime = 0;
        video.play();
    }

    override function pause() {
        video.pause();
    }

    override function resume() {
        //video.currentTime = ;
        video.play();
    }

    override function stop() {
        video.pause();
        video.currentTime = 0;
    }

    override function render() {
        context.save();
        context.scale( vision.display.width / video.videoWidth, vision.display.height / video.videoHeight );
        context.drawImage( video, 0, 0 );
        context.restore();
    }

    function load( path : String ) {
        return new Promise( function(resolve,reject) {
            video.src = 'file://$path';
            video.oncanplaythrough = function() {
                video.oncanplaythrough = null;
                resolve( this );
                //start();
            }
        });
    }

}
