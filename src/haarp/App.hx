package haarp;

import haxe.Json;
import js.Browser.console;
import js.Browser.document;
import js.Browser.navigator;
import js.Browser.window;
import js.node.Fs;
import om.Activity;
import haarp.net.Server;

/*
private typedef ModuleConfig = {
    var name : String;
    var type : String;
    var params : Array<Dynamic>;
}

private typedef VisionConfig = {
    var name : String;
    var modules : Array<ModuleConfig>;
}
*/

class App implements om.App {

    public static inline var RES = '/home/tong/dev/HAARP';
    public static inline var WEB = 'http://localhost/HAARP';

    //public static var ip(default,null) : String;

    //public static var vision(default,null) : Vision;

    //static var server : Server;
    /*
    static function load( name : String ) {

        console.group( name );

        var intro = new haarp.app.IntroActivity();
        Activity.boot( intro );

        vision = new Vision();

        /*
        Fs.readFile( '$RES/vision/$name.json', 'utf8', function(e,data) {
            var cfg : VisionConfig = Json.parse( data );
            var modules = new Array<Module>();
            for( mod in cfg.modules ) {
                trace(mod);
                trace( 'haarp.module.'+mod.type );
                trace( Type.resolveClass( 'haarp.module.'+mod.type ) );
                //trace( Type.createInstance( 'haarp.module.'+mod.name, [] ) );
            }
        } );
        * /

        vision.init(
            [
                new haarp.module.Sound( '$WEB/sound/head-1-cut.wav' ),
                //new haarp.module.Sound( '$WEB/sound/airplane.wav', true ),
                //new haarp.module.Drzllect( '$RES/image/archillect' ),
                //new haarp.module.VideoPlayer( '$RES/video/natural_born_killers/natural_born_killer_01.mp4' ),
                new haarp.module.VideoPlayer( '$RES/video/sayat_nova/sayat_nova-19.mp4' ),
                new haarp.module.SoundSpectrum(),
                /*
                new haarp.module.Group([
                    new haarp.module.VideoPlayer( '$RES/video/sayat_nova/sayat_nova-19.mp4' ),
                    new haarp.module.SoundSpectrum(),
                ]),
                * /
                //new haarp.module.TestModule(1000),
                new haarp.module.HMDHost( ip, 7000 ),
                //new haarp.module.RemoteStream( ip, 8000 ),
            ],
            function() {
                intro.replace( new haarp.app.VisionActivity( vision ) );
            }
        );
    }
    */

    static inline function init() {

        console.info( 'H  A  A  R  P' );

        var vision = window.location.search.substr( 1 );
        Activity.boot( new haarp.app.BootActivity( vision ) );
    }

}
