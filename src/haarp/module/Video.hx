package haarp.module;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.VideoElement;
import js.html.CanvasRenderingContext2D;
import js.node.Fs;

class Video extends Module {

    public var path(default,null) : String;
    //public var video(default,null) : VideoElement;
    public var playbackRate(get,set) : Float;
    inline function get_playbackRate() return video.playbackRate;
    inline function set_playbackRate(v) return video.playbackRate = v;

    //var videos : Array<VideoElement>;
    var video : VideoElement;
    var ctx : CanvasRenderingContext2D;
    var index = 0;

    public function new( path : String ) {
        super();
        this.path = path;
    }

    override function init( vision : Vision, ?callback : Void->Void ) {

        super.init( vision );

        ctx = vision.canvas.getContext2d();
        //ctx.imageSmoothingEnabled = false;
        //ctx.filter = 'opacity(20%)';

        //videos = [];

        trace(path);

        /*
        Fs.readdir( path, function(e,files) {
            if( e != null ) {
                trace(e);
                callback(); //TODO
            } else {
                function loadVideo( i : Int ) {
                    var video = document.createVideoElement();
                    video.src = 'http://localhost/HAARP/video/'+files[i];
                    video.autoplay = false;
                    video.loop = false;
                    video.onerror = function(e) {
                        trace( e );
                    }
                    video.oncanplaythrough = function() {
                        video.oncanplaythrough = null;
                        videos.push( video );
                        trace(videos.length+":");
                        if( videos.length == files.length ) {
                            callback();
                        } else {
                            loadVideo( videos.length );
                        }
                    }
                }
                loadVideo( 0 );
            }
        });
        */

        /*
        Fs.readdir( path, function(e,files) {
            if( e != null ) {
                trace(e);
                callback(); //TODO
            } else {
                for( i in 0...files.length ) {
                    var url = 'http://localhost/HAARP/video/'+files[i];
                    var video = document.createVideoElement();
                    video.autoplay = false;
                    video.loop = true;
                    video.src = url;
                    video.oncanplaythrough = function() {
                        video.oncanplaythrough = null;
                        //callback();
                        videos.push( video );
                        trace(videos.length+":"+url);
                        if( videos.length == files.length ) {
                            callback();
                        }

                    }
                }
            }
        } );
        */

        var url = path+'/sayat_nova-4.mp4';

        video = document.createVideoElement();
        video.src = url;
        video.muted = true;
        video.controls = false;
        video.autoplay = false;
        video.loop = true;
        load( url, callback );
        /*
        video.oncanplaythrough = function() {
            trace(video.duration);
            video.oncanplaythrough = null;
            callback();
        }
        */
    }

    override function start() {
        video.play();
    }

    override function stop() {
        video.pause();
    }

    override function update() {

        //var video = videos[index];
        //trace(vision.canvas.width,video.width);

        ctx.save();
        ctx.scale( vision.canvas.width / video.videoWidth, vision.canvas.height / video.videoHeight );
        ctx.drawImage( video, 0, 0 );
        ctx.restore();
    }

    public function load( url : String, callback : Void->Void ) {
        video.oncanplaythrough = function() {
            video.oncanplaythrough = null;
            callback();
        }
        video.src = url;
        video.muted = true;
    }

}
