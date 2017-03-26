package haarp.module;

import js.Promise;

class Timeline extends Module {

    var times : Array<Float>;
    var handlers : Array<Void->Void>;
    //var index : Int;

    /*
    public function new( ?map : Map<Int,Void->Void> ) {

        super();

        clear();
        index = 0;

        if( map != null ) {
            //TODO sort
            for( key in map.keys() ) {
                times.push( key );
                handlers.push( map.get( key ) );
            }
        }
    }
    */

    public function new() {
        super();
        clear();
    }


    override function update( time : Float ) {

        if( time*1000 > times[0]/100 ) {
            var t = times.shift();
            var h = handlers.shift();
            h();
        }
        /*
        var i = 0;
        while( i < times.length ) {
            if( time > times[i] ) {
                break;
            }
            i++;
        }
        */
        //trace( Std.int(time) +' ::: '+ times[0] );
        /*
        if( time*100 > times[0] ) {
            trace("SSSSSSSSSSS");
        }
        */
        /*
        var j = 0;
        for( i in 0...times.length ) {
            if( time*1000 > times[i] ) {
                j = i;
                break;
            }
        }
        trace(j);
        */
    }

    public function add( time : Int, handler : Void->Void ) {
        if( times.length == 0 ) {
            times.push( time );
        } else {
            for( i in 0...times.length ) {
                var j = times.length - (i+1);
                if( time > times[j] ) {
                    times.insert( j+1, time );
                    handlers.insert( j+1, handler );
                    break;
                }
            }
        }
    }

    public function clear() {
        times = [];
        handlers = [];
    }

}
