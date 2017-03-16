package haarp;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;

class App implements om.App {

    static function load( vision : String ) {

        console.group( vision );

        document.body.innerHTML = '';

        /*
        window.fetch( 'vision/$name.json' ).then( function(res){
            trace( res );
        });
        */

        om.Activity.boot( new haarp.app.PreloadActivity( vision ) );
    }

    static function init() {
        console.info( 'H  A  A  R  P' );
        load( 'head-1' );
    }

}
