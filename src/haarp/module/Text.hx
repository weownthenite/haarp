package haarp.module;

class Text extends Module {

    public var text(default,null) : String;
    public var x(default,null) : Int;
    public var y(default,null) : Int;
    public var font(default,null) : String;
    public var style(default,null) : String;

    public function new( text : String, x = 0, y = 0, font = '32px Noto Sans', style = '#fff' ) {
        super();
        this.text = text;
        this.x = x;
        this.y = y;
        this.font = font;
        this.style = style;
    }

    override function render() {
        if( text != null && text.length > 0 ) {
            var ctx = vision.display.getContext2d();
            ctx.save();
            ctx.font = font;
            ctx.fillStyle = style;
            ctx.fillText( text, x, y );
            ctx.restore();
        }
    }

}
