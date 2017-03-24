package haarp;

import js.Promise;

class Module {

    public var vision(default,null) : Vision;
    public var enabled : Bool;
    public var started(default,null) : Bool;

    public function new( enabled = true ) {
        this.enabled = enabled;
        started = false;
    }

    function init<T:Module>() : Promise<T> {
        return Promise.resolve();
    }

    function start() {}

    function stop() {}

    function update( time : Float ) {}

    function render() {}

    function dispose() {}

    inline function toggleStart() started ? stop() : start();
}
