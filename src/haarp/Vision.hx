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
    public var frameTime(default,null) : Float;
    //public var time(default,null) : Float;
    public var audio(default,null) : Audio;
    public var display(default,null) : Display;

    var modules : Array<Module>;

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

        frameTime = Time.now();
        started = true;

        for( m in modules ) {
            m.started = true;
            m.start();
        }

        emit( 'start', Time.now() );
    }

    public function stop() {

        started = false;

        for( m in modules ) {
            m.started = false;
            m.stop();
        }

        emit( 'stop', Time.now() );
    }

    public function update( time : Float ) {

        frameTime = time;

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
        //stop();
        started = false;
        for( m in modules ) m.dispose();
        modules = [];
    }

}
