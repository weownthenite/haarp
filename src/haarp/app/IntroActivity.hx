package haarp.app;

import js.Browser.document;

class IntroActivity extends om.Activity {

    override function onCreate() {

        super.onCreate();

        var title = document.createDivElement();
        title.classList.add( 'title' );
        title.textContent = 'H  A  A  R  P';
        element.appendChild( title );
    }

}
