package haarp.module;

import js.Browser.document;
import js.html.CanvasRenderingContext2D;
import js.html.DivElement;

class DebugInfo extends Module {

    var element : DivElement;

    public function new() {

        super();

        element = document.createDivElement();
        element.style.position = 'fixed';
        element.style.right = '1px';
        element.style.bottom = '1px';
        element.style.zIndex = '10000';
        element.style.cursor = 'default';
        untyped element.style.webkitUserSelect = 'none';
    }

    override function start() {
        document.body.appendChild( element );
    }

    override function stop() {
        element.remove();
    }

    @:access(haarp.Vision)
    override function update() {
        var info = Std.int( om.Time.now() ) + '/' + vision.modules.length;
        element.textContent = info;
    }

}
