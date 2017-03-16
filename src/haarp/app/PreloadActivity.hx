package haarp.app;

import js.Browser.console;
import js.Browser.document;
import om.Time.now;
import haarp.module.*;

class PreloadActivity extends om.Activity {

    var name : String;

    public function new( name : String ) {
        super();
        this.name = name;
    }

    override function onCreate() {

        super.onCreate();

        /*
        var spinner = document.createDivElement();
        spinner.classList.add( 'spinner' );
        element.appendChild( spinner );
        */

        var title = document.createDivElement();
        title.textContent = 'LOADING VISION [$name]';
        element.appendChild( title );
    }

    override function onStart() {

        super.onStart();

        var res = '/home/tong/dev/HAARP';
        var web = 'http://localhost/HAARP';

        var modules : Array<Module> = [
            new Sound( '$web/sound/head-1-cut.wav' ),
            //new Drzllect( '$res/image/archillect' ),
            //new Strobo(),
            new Oscillator(),
            //new DrzllectModule( '$web/image/archillect' ),
            //video,
            //new VideoModule( '$res/video' ),
            //new VideoModule( '$http/video' ),
            //new RandomColorModule(0,1000),
            #if debug
            //new DebugInfoModule()
            #end
        ];

        console.group( 'init '+modules.length+' modules' );

        var startTime = now();

        Vision.init( 'head-1', modules, function(vision) {

            console.log( '['+Std.int(now()-startTime)+'ms]' );
            console.groupEnd();

            //var inf = new Influence( sound, );

            //sound
            //vision.on( '' );
            //var p = new js.html.Proxy();

            replace( new VisionActivity( vision ) );
        });
    }

}
