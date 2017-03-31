package haarp;

import js.Promise;
import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageBitmap;
import om.Time;

private enum State {
    //create;
    //init;
    //idle;
    Play;
    Pause;
    Stop;
    //end;
}

@:access(haarp.Module)
class Vision {

    public dynamic function onDispose() {}

    public var name(default,null) : String;
    public var state(default,null) : State;
    //public var started(default,null) : Bool;
    public var time(default,null) : Float;
    public var audio(default,null) : Audio;
    public var display(default,null) : Display;

    //var volume : Float;

    var timeStart : Float;
    var timePauseStart : Float;
    var timePauseOffset : Float;

    var modules : Array<Module>;

    function new( name : String, canvas : CanvasElement ) {

        this.name = name;

        //state = create;
        time = timePauseOffset = 0;

        modules = [];

        audio = new Audio();
        display = new Display( canvas );
    }

    public function init() : Promise<Dynamic> {
        //state = State.init;
        return Promise.all( [for(m in modules) m.init()] ).then( function(_){
            state = Stop;
        });
    }

    public function add( module : Module ) {
        module.vision = this;
        modules.push( module );
    }

    public function remove( module : Module ) {
        modules.remove( module );
    }

    public function start() {

        console.log( 'Vision Start' );

        state = Play;
        timeStart = Time.now();
        time = 0;

        for( m in modules ) {
            //m.state = play;
            m.start();
        }
    }

    public function pause() {
        state = Pause;
        timePauseStart = time;
        for( m in modules ) m.pause();
    }

    public function resume() {
        state = Play;
        timePauseOffset += time - timePauseStart;
        timePauseStart = null;
        for( m in modules ) m.resume();
    }

    public function stop() {

        state = Stop;
        time = 0;
        timeStart = -1;

        for( m in modules ) {
            //m.started = false;
            //m.state = idle;
            m.stop();
        }
    }

    public function update() {

        //switch state {
        //case Play,Pause:
        var now = Time.now();
        time = (now - timeStart - timePauseOffset) / 1000;

        audio.update();

        for( m in modules ) {
            if( m.enabled ) m.update( time );
        }
    }

    public function render() {
        if( state == Play ) {
            if( display.autoClear ) display.clear();
            for( m in modules ) {
                if( m.enabled ) m.render();
            }
        }
    }

    public function dispose() {

        stop();

        for( m in modules ) m.dispose();

        audio.dispose();

        display.clear();
        display.dispose();

        onDispose();
    }

}
