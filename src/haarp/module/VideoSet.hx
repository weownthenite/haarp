package haarp.module;

import js.Browser.document;
import js.Promise;
import js.html.MediaElement;
import js.html.VideoElement;
import js.html.CanvasRenderingContext2D;
import js.node.Fs;
import om.util.ArrayUtil;

class VideoSet extends Module {

    public dynamic function onVideoEnd( index : Int ) {}
    public dynamic function onComplete() {}

    public var path(default,null) : String;
    public var files(default,null) : Array<String>;
    public var loop : Bool;

    public var playbackRate(get,set) : Float;
    inline function get_playbackRate() return video.playbackRate;
    inline function set_playbackRate(v:Float) return video.playbackRate = v;

    //public var time(default,null) : Float;
    //inline function get_playbackRate() return video.playbackRate;
    //inline function set_playbackRate(v:Float) return video.playbackRate = v;

    var index : Int;
    var video : VideoElement;

    public function new( path : String, loop = false ) {
        super();
        this.path = path;
        this.loop = loop;
    }

    override function init() {

        return new Promise( function(resolve,reject){

            Fs.readdir( path, function(e,files){

                if( e != null ) reject(e) else {

                    this.files = files;

                    video = document.createVideoElement();
                    video.autoplay = false;
                    video.muted = true;
                    video.loop = loop;
                    trace(video.playbackRate);
                    /*
                    video.oncanplaythrough = function() {
                        trace("oncanplaythrough");
                        video.oncanplaythrough = null;
                    }
                    */
                    video.addEventListener( 'ended', function(e) {
                        onVideoEnd( index );
                        if( index == files.length ) onComplete();
                        if( !loop ) {
                            loadNext( function(){
                                video.play();
                            });
                        }
                    } );

                    index = 0;
                    load( 0, function(){
                        resolve( cast this );
                    } );
                }
            });
        });
    }

    override function start() {
        video.currentTime = 0;
        video.play();
    }

    override function pause() {
        video.pause();
    }

    override function resume() {
        video.play();
    }

    override function stop() {
        video.pause();
        video.currentTime = 0;
    }

    override function render() {
        var ctx = vision.display.getContext2d();
        ctx.save();
        //ctx.globalCompositeOperation = 'screen';
        ctx.scale( vision.display.width / video.videoWidth, vision.display.height / video.videoHeight );
        ctx.drawImage( video, 0, 0 );
        ctx.restore();
    }

    public function load( i : Int, ?callback : Void->Void ) {

        //if( i < 0 ) i = 0 else if( i >= files.length ) i = files.length - 1;

        //TODO block if loading
        //if( )

        index = i;
        //trace(index);

        if( video.readyState == MediaElement.HAVE_ENOUGH_DATA ||
            video.readyState == MediaElement.HAVE_NOTHING ) {
            video.src = 'file://$path/'+files[index];
            video.oncanplaythrough = function() {
                if( callback != null ) callback();
                video.play();
            }
        } else {
            if( callback != null ) callback();
        }

        /*
        var nVideo = document.createVideoElement();
        nVideo.autoplay = false;
        nVideo.muted = true;
        nVideo.loop = loop;
        nVideo.src = 'file://$path/'+files[index];
        nVideo.oncanplaythrough = function() {
            video = nVideo;
            if( callback != null ) callback();
            video.play();
        }
        nVideo.addEventListener( 'ended', function(e) {
            //onEnd();
            if( !loop ) {
                loadNext();
                //video.play();
            }
        } );
        */
    }

    public function loadNext( ?callback : Void->Void ) {
        if( ++index == files.length ) index = 0;
        load( index, callback );
    }

    public function loadPrev( ?callback : Void->Void ) {
        if( --index == -1 ) index = files.length - 1;
        load( index, callback );
    }

    public function loadRandom() {
        load( Math.floor( Math.random() * files.length ) );
    }

    public inline function shuffle() {
        ArrayUtil.shuffle( files );
    }

}
