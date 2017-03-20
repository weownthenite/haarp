package haarp.app;

import js.Browser.console;
import js.Browser.document;
import haarp.App.RES;
import haarp.App.WEB;

class BootActivity extends om.Activity {

    var visionName : String;

    public function new( visionName : String ) {
        super();
        this.visionName = visionName;
    }

    override function onCreate() {

        super.onCreate();

        var title = document.createDivElement();
        title.classList.add( 'title' );
        title.textContent = 'H  A  A  R  P - '+visionName;
        element.appendChild( title );
    }

    override function onStart() {

        super.onStart();

        console.group( 'Loading $visionName' );

        var ip = om.Network.getLocalIP()[0];

        var vision = new Vision();
        vision.init(
            [
                new haarp.module.Sound( '$WEB/sound/head-1-cut.wav' ),
                //new haarp.module.Sound( '$WEB/sound/airplane.wav', true ),
                //new haarp.module.Drzllect( '$RES/image/archillect' ),
                //new haarp.module.VideoPlayer( '$RES/video/natural_born_killers/natural_born_killer_01.mp4' ),
                //new haarp.module.VideoPlayer( '$RES/video/natural_born_killers/natural_born_killer_02.mp4' ),
                new haarp.module.SoundSpectrum(),
                /*
                new haarp.module.Group([
                    new haarp.module.VideoPlayer( '$RES/video/sayat_nova/sayat_nova-19.mp4' ),
                    new haarp.module.SoundSpectrum(),
                ]),
                */
                //new haarp.module.Strobo( 16, 16 ),
                //new haarp.module.TestModule(1000),
                new haarp.module.HMDHost( ip, 7000 ),
                //new haarp.module.RemoteStream( ip, 8000 ),
            ],
            function() {
                console.groupEnd();
                replace( new haarp.app.VisionActivity( vision ) );
            }
        );
    }
}
