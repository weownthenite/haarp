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

    static inline function init() {

        console.info( 'H  A  A  R  P' );

        var vision = window.location.search.substr( 1 );
        Activity.boot( new haarp.app.BootActivity( vision ) );
    }

}
