package haarp.module;

using StringTools;

@:allow(haarp.Vision)
class AbstractModule implements Module {

    static inline var NAME_POSTFIX = 'Module';

    public var name(default,null) : String;
    public var vision(default,null) : Vision;

    public var enabled : Bool;
    //public var alpha : Bool; //TODO on layer
    //public var fx : Bool; //TODO on layer

    public function new( ?name : String, enabled = true ) {

        if( name == null ) {
            var cname = Type.getClassName( Type.getClass( this ) );
            var i = cname.lastIndexOf( '.' );
            if( i != -1 ) cname = cname.substring( i+1 );
			if( cname.endsWith( NAME_POSTFIX ) ) {
                cname = cname.substring( 0, cname.length - NAME_POSTFIX.length );
            }
            //name = cname.toLowerCase();
            name = cname;
        }

        this.name = name;
        this.enabled = enabled;
    }

    public function init( ?callback : Void->Void ) {
        if( callback != null ) callback();
    }

    public function start() {
    }

    public function update() {
    }

    public function render() {
    }

    public function stop() {
    }

    public function dispose() {
    }
}
