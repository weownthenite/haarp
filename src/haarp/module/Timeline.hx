package haarp.module;

import js.Promise;

class Timeline extends Module {

    var times : Array<Float>;
    var handlers : Array<Void->Void>;
    var index : Int;

    public function new( map : Map<Int,Void->Void> ) {

        super();

        clear();
        //TODO sort
        for( key in map.keys() ) {
            times.push( key );
            handlers.push( map.get( key ) );
        }

        index = 0;
    }

    override function update( time : Float ) {
        //trace( time, times );

        for( i in index...times.length ) {
            if( time * 1000 > times[index] ) {
                handlers[index]();
                index++;
            }
        }

        /*
        for( i in index...times.length-1 ) {
            var e = times[i] / 1000;
            if( time > e ) {
                index++;
                handlers[index]();
            }
        }
        */
    }

    /*
    public function setHandler( time : Int, handler : Void->Void ) {
        for( i in 0...times.length ) {
            var j = times.length - (i+1);
            if( time > times[j] ) {
                times.insert( j+1, time );
                handlers.insert( j+1, handler );
                break;
            }
        }
    }
    */

    public function clear() {
        times = [];
        handlers = [];
    }

}
