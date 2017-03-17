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

    public static var ip(default,null) : String;

    public static var vision(default,null) : Vision;

    static var server : Server;

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
        */

        vision.init(
            [
                new haarp.module.Sound( '$WEB/sound/head-1-cut.wav' ),
                //new haarp.module.Sound( '$WEB/sound/airplane.wav', true ),
                new haarp.module.Drzllect( '$RES/image/archillect' ),
                new haarp.module.Oscillator(),
                //new haarp.module.TestModule(1000),
                new haarp.module.HMDHost( ip, 7000 ),
            ],
            function() {
                intro.replace( new haarp.app.VisionActivity( vision ) );
            }
        );
    }

    static function init() {

        console.info( 'H  A  A  R  P' );

        document.body.innerHTML = '';

        ip = om.Network.getLocalIP()[0];
        //ip = om.Network.getLocalIP()[1];
        //trace("MYIP: "+ip );

        var visionName = window.location.search.substr( 1 );
        load( visionName );
    }

}
