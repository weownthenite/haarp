package haarp.module;

import js.Browser.document;
import js.Promise;
import js.html.MediaElement;
import js.html.VideoElement;
import js.html.CanvasRenderingContext2D;
import js.node.Fs;
import sys.FileSystem;

import om.util.ArrayUtil;

using StringTools;
using haxe.io.Path;

class VideoManager extends Module {

    public var path(default,null) : String;

    var sets : Array<Array<String>>;
    var setIndex : Int;
    var fileIndex : Int;
    var video : VideoElement;
    var context : CanvasRenderingContext2D;

    public function new( path : String ) {
        super();
        this.path = path;
        setIndex = 0;
        fileIndex = 0;
    }

    override function init() {

        return new Promise( function(resolve,reject){

            context = vision.display.getContext2d();
            sets = [];

            Fs.readdir( path, function(e,setPaths){
                if( e != null ) reject(e) else {
                    //this.setPaths = setPaths;
                    for( setPath in setPaths ) {

                        Fs.readdir( '$path/$setPath', function(e,files){
                            if( e != null ) reject(e) else {
                                var usedFiles = new Array<String>();
                                for( f in files ) {
                                    if( f.startsWith( '_' ) || f.extension() != 'mp4' )
                                        continue;
                                    usedFiles.push( path+'/'+setPath+'/'+f );
                                }

                                sets.push( usedFiles );

                                if( sets.length == setPaths.length ) {

                                    video = document.createVideoElement();
                                    video.autoplay = false;
                                    video.muted = true;
                                    video.loop = true;
                                    //video.playbackRate = 10.0;

                                    resolve( cast this );
                                }
                            }
                        });
                    }
                }
            });
        });
    }

    override function start() {
        //video.currentTime = 0;
        //video.play();
    }

    override function pause() {
        //video.pause();
    }

    override function resume() {
        //video.play();
    }

    override function stop() {
        //video.pause();
        //video.currentTime = 0;
    }

    override function render() {
        context.save();
        context.scale( vision.display.width / video.videoWidth, vision.display.height / video.videoHeight );
        context.drawImage( video, 0, 0 );
        context.restore();
    }

    public function loadNextVideo( ?callback : Void->Void ) {
        if( ++fileIndex == sets[setIndex].length ) {
            fileIndex = 0;
            /*
            if( ++setIndex == sets.length ) {
                setIndex = 0;
            }
            */
        }
        loadVideo();
    }

    public function loadPrevVideo() {
        if( --fileIndex == -1 ) {
            fileIndex = sets[setIndex].length - 1;
            /*
            if( --setIndex == -1 ) {
                setIndex = sets.length -1;
                fileIndex = 0;
            }
            */
        }
        loadVideo();
    }

    public function loadNextSet() {
        if( ++setIndex == sets.length ) {
            setIndex = 0;
        }
        fileIndex = 0;
        loadVideo();
    }

    public function loadPrevSet() {
        if( --setIndex == -1 ) {
            setIndex = sets.length -1;
        }
        fileIndex = 0;
        loadVideo();
    }

    function loadVideo( ?callback : Void->Void ) {
        if( video.readyState == MediaElement.HAVE_ENOUGH_DATA ||
            video.readyState == MediaElement.HAVE_NOTHING ) {
            var url = 'file://'+sets[setIndex][fileIndex];
            video.src = url;
            video.oncanplaythrough = function() {
                if( callback != null ) callback();
                video.play();
            }
        } else {
            if( callback != null ) callback();
        }
    }

    /////////////////

    /*
    function load( i : Int, ?callback : Void->Void ) {

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
        * /
    }
    */

    /*
    public function loadNext( ?callback : Void->Void ) {
        //trace(index);
        if( ++index == files.length ) {
            setIndex++;
            index = 0;
        }
        //load( index, callback );
    }

    public function loadPrev( ?callback : Void->Void ) {
        //if( --index == -1 ) index = files.length - 1;
        //load( index, callback );
    }

    public function loadRandom() {
        //load( Math.floor( Math.random() * files.length ) );
    }

    public inline function shuffle() {
        //ArrayUtil.shuffle( files );
    }
    */

}
