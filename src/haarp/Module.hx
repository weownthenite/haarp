package haarp;

import js.Promise;

/*
private enum State {
    create;
    init;
    idle;
    play;
    pause;
    end;
}
*/

class Module {

    //public var state(default,null) = State.create;
    public var enabled : Bool;
    //started = false;
    //public var started(default,null) : Bool;

    var vision : Vision;

    public function new( enabled = true ) {
        this.enabled = enabled;
    }

    function init<T:Module>() : Promise<T> {
        return Promise.resolve();
    }

    function start() {}

    function stop() {}

    function pause() {}

    function resume() {}

    function update( time : Float ) {}

    function render() {}

    function dispose() {}

    //inline function toggleStart() started ? stop() : start();
}
