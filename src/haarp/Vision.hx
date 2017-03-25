package haarp;

import js.Promise;
import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageBitmap;
import om.Time;

@:access(haarp.Module)
class Vision extends om.EventEmitter {

    public var name(default,null) : String;
    public var started(default,null) : Bool;
    public var time(default,null) : Float;
    public var audio(default,null) : Audio;
    public var display(default,null) : Display;

    var modules : Array<Module>;
    var startTime : Float;

    function new( name : String, canvas : CanvasElement ) {

        super();
        this.name = name;

        started = false;
        modules = [];

        audio = new Audio();

        display = new Display( canvas );
    }

    public function init() : Promise<Dynamic> {
        return Promise.all( [for(m in modules) m.init()] );
    }

    public function add( module : Module ) {
        module.vision = this;
        modules.push( module );
    }

    public function start() {

        time = 0;
        startTime = Time.now();
        started = true;

        for( m in modules ) {
            m.started = true;
            m.start();
        }

        emit( 'start', Time.now() );
    }

    public function stop() {

        started = false;
        time = startTime = null;

        for( m in modules ) {
            m.started = false;
            m.stop();
        }

        emit( 'stop', Time.now() );
    }

    public function update() {

        var now = Time.now();
        time = now - startTime;

        audio.update();

        for( m in modules ) {
            if( m.enabled ) m.update( time );
        }
    }

    public function render() {

        display.clear();

        for( m in modules ) {
            if( m.enabled ) m.render();
        }
    }

    public function dispose() {
        stop();
        for( m in modules ) m.dispose();
        modules = [];
    }

}
