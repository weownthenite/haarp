package haarp.app;

class ErrorActivity extends om.Activity {

    var info : String;

    public function new( info : String ) {
        super();
        this.info = info;
    }

    override function onCreate() {
        super.onCreate();
        element.textContent = info;
    }

}
