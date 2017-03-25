package haarp.module;

import js.html.Path2D;

/**
    2D mask.
**/
class Mask extends Module {

    public var path : Path2D;

    public function new( path : Path2D ) {
        super();
        this.path = path;
    }

    override function render() {
        if( path != null ) {
            vision.display.clip( path );
        }
    }
}
