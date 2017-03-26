package haarp.module;

import js.Browser.console;
import js.Browser.navigator;
import js.html.GamepadButton;

typedef AnalogStick = {
    var x : Float;
    var y : Float;
}

class Gamepad extends Module {

    static var BTN_NIL = { pressed: false, value:0 };

    public dynamic function onConnect() {}
    public dynamic function onButtonPress( id : String ) {}
    public dynamic function onButtonRelease( id : String ) {}
    public dynamic function onStick( id : String, value : AnalogStick ) {}

    public var id(get,null) : String;
    inline function get_id() return (device == null) ? null : device.id;

    public var connected(get,null) : Bool;
    inline function get_connected() return (device == null) ? false : device.connected;

    public var buttons(get,null) : Array<GamepadButton>;
    inline function get_buttons() return (device == null) ? [] : device.buttons;

    public var axes(get,null) : Array<Float>;
    inline function get_axes() return (device == null) ? [] : device.axes;

    public var A(default,null) = false;
    public var B(default,null) = false;
    public var X(default,null) = false;
    public var Y(default,null) = false;

    public var L1(default,null) = false;
    public var R1(default,null) = false;

    public var BACK(default,null) = false;
    public var START(default,null) = false;
    public var POWER(default,null) = false;

    public var LS(default,null) = false;
    public var RS(default,null) = false;

    public var LEFT(default,null) = false;
    public var RIGHT(default,null) = false;
    public var UP(default,null) = false;
    public var DOWN(default,null) = false;

    public var STICK_L(default,null) : AnalogStick = { x:0, y:0 };
    public var STICK_R(default,null) : AnalogStick = { x:0, y:0 };

    //TODO L2/R2 analog buttons

    public var devices(default,null) : Array<js.html.Gamepad>;

    var device : js.html.Gamepad;

    public function new() {
        super();
        devices = [];
    }

    override function update( time : Float ) {

        var devices = navigator.getGamepads();
        for( i in 0...devices.length ) {
            if( devices[i] == null ) {
                //
            } else {
                if( devices[i] != this.devices[i] ) {
                    console.log( 'New gamepad detected' );
                    this.devices[i] = devices[i];
                    if( this.device == null ) {
                        console.log( 'Gamepad connected' );
                        this.device = devices[i];

                    }
                }
            }
        }

        if( device != null && device.connected ) {

            ///// Buttons

            var _A = device.buttons[0].pressed;
            var _B = device.buttons[1].pressed;
            var _X = device.buttons[2].pressed;
            var _Y = device.buttons[3].pressed;

            var _L1 = device.buttons[4].pressed;
            var _R1 = device.buttons[5].pressed;

            var _BACK = device.buttons[6].pressed;
            var _START = device.buttons[7].pressed;
            var _POWER = device.buttons[8].pressed;

            var _LS = device.buttons[9].pressed;
            var _RS = device.buttons[10].pressed;

            var _LEFT = device.buttons[11].pressed;
            var _RIGHT = device.buttons[12].pressed;
            var _UP = device.buttons[13].pressed;
            var _DOWN = device.buttons[14].pressed;

            var pressed = new Array<String>();
            var released = new Array<String>();

            if( _A != A ) {
                A = _A;
                _A ? pressed.push( 'A' ) : released.push( 'A' );
            }
            if( _B != B ) {
                B = _B;
                _B ? pressed.push( 'B' ) : released.push( 'B' );
            }
            if( _X != X ) {
                X = _X;
                _X ? pressed.push( 'X' ) : released.push( 'X' );
            }
            if( _Y != Y ) {
                Y = _Y;
                _Y ? pressed.push( 'Y' ) : released.push( 'Y' );
            }
            if( _L1 != L1 ) {
                L1 = _L1;
                _L1 ? pressed.push( 'L1' ) : released.push( 'L1' );
            }
            if( _R1 != R1 ) {
                R1 = _R1;
                _R1 ? pressed.push( 'R1' ) : released.push( 'R1' );
            }
            if( _BACK != BACK ) {
                BACK = _BACK;
                _BACK ? pressed.push( 'BACK' ) : released.push( 'BACK' );
            }
            if( _START != START ) {
                START = _START;
                _START ? pressed.push( 'START' ) : released.push( 'START' );
            }
            if( _POWER != POWER ) {
                POWER = _POWER;
                _POWER ? pressed.push( 'POWER' ) : released.push( 'POWER' );
            }
            if( _LS != LS ) {
                LS = _LS;
                _LS ? pressed.push( 'LS' ) : released.push( 'LS' );
            }
            if( _RS != RS ) {
                RS = _RS;
                _RS ? pressed.push( 'RS' ) : released.push( 'RS' );
            }
            if( _LEFT != LEFT ) {
                LEFT = _LEFT;
                _LEFT ? pressed.push( 'LEFT' ) : released.push( 'LEFT' );
            }
            if( _RIGHT != RIGHT ) {
                RIGHT = _RIGHT;
                _RIGHT ? pressed.push( 'RIGHT' ) : released.push( 'RIGHT' );
            }
            if( _UP != UP ) {
                UP = _UP;
                _UP ? pressed.push( 'UP' ) : released.push( 'UP' );
            }
            if( _DOWN != DOWN ) {
                DOWN = _DOWN;
                _DOWN ? pressed.push( 'DOWN' ) : released.push( 'DOWN' );
            }

            for( btn in pressed ) onButtonPress( btn );
            for( btn in released ) onButtonRelease( btn );

            ///// Axes

            //trace(device.axes[1]);
            //var moved = new Array<>();

            var _STICK_L : AnalogStick = { x: device.axes[0], y: device.axes[1] };
            if( _STICK_L.x != STICK_L.x || _STICK_L.y != STICK_L.y ) {
                STICK_L.x = _STICK_L.x;
                STICK_L.y = _STICK_L.y;
                onStick( 'L', STICK_L );
            }
            var _STICK_R : AnalogStick = { x: device.axes[2], y: device.axes[3] };
            if( _STICK_R.x != STICK_R.x || _STICK_R.y != STICK_R.y ) {
                STICK_R.x = _STICK_R.x;
                STICK_R.y = _STICK_R.y;
                onStick( 'R', STICK_R );
            }

            //for( stick in moved ) onButtonPress( btn );
        }
    }

    override function dispose() {
        devices = [];
    }

}
