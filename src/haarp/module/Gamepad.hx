package haarp.module;

import js.Browser.console;
import js.Browser.navigator;
import js.html.GamepadButton;

class Gamepad extends Module {

    public static inline var A = 0;
    public static inline var B = 1;
    public static inline var X = 2;
    public static inline var Y = 3;

    public static inline var L1 = 4;
    public static inline var R1 = 5;

    public static inline var BACK = 6;
    public static inline var START = 7;
    public static inline var POWER = 8;

    public static inline var LS = 9;
    public static inline var RS = 10;

    public static inline var DL = 11;
    public static inline var DR = 12;
    public static inline var DT = 13;
    public static inline var DB = 14;

    public static inline var LX = 0;
    public static inline var LY = 1;

    public static inline var RX = 3;
    public static inline var RY = 4;

    public dynamic function onButtonPress( i : Int ) {}
    public dynamic function onButtonRelease( i : Int ) {}

    public var device(get,never) : js.html.Gamepad;
    inline function get_device() return navigator.getGamepads()[0];

    public var axe(default,null) : Array<Float>;
    //inline function get_axe() return navigator.getGamepads()[0];

    public var button(default,null) : Array<Bool>;
    //inline function get_axe() return navigator.getGamepads()[0];
    //var buttons : Array<Bool>;

    public function new() {
        super();
        button = [];
    }

    override function update( time : Float ) {

        var dev = navigator.getGamepads()[0];

        if( dev != null ) {

            axe = dev.axes;

            var btn = dev.buttons;
            for( i in 0...btn.length ) {
                if( button[i] ) {
                    if( !btn[i].pressed ) onButtonRelease( i );
                } else {
                    if( btn[i].pressed ) onButtonPress( i );
                }
                button[i] = btn[i].pressed;
            }


            /*
            var _A = dev.buttons[0].pressed;
            var _B = dev.buttons[1].pressed;
            var _X = dev.buttons[2].pressed;
            var _Y = dev.buttons[3].pressed;

            var _BACK = dev.buttons[6].pressed;
            var _START = dev.buttons[7].pressed;
            var _POWER = dev.buttons[8].pressed;

            var _D.l = dev.buttons[11].pressed;
            var _D.r = dev.buttons[12].pressed;
            var _D.t = dev.buttons[13].pressed;
            var _D.b = dev.buttons[14].pressed;

            var _L2 = dev.axes[2];
            var _R2 = dev.axes[5];

            var _LS.x = dev.axes[0];
            var _LS.y = dev.axes[1];
            var _LS.pressed = dev.buttons[9].pressed;

            var _RS.x = dev.axes[3];
            var _RS.y = dev.axes[4];
            var _RS.pressed = dev.buttons[10].pressed;
            */
        }
    }

}


/*
class Gamepad extends Module {

    static var BTN_NIL = { pressed: false, value:0 };

    public dynamic function onConnect() {}
    public dynamic function onButtonPress( id : String, ?value : Float ) {}
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

    //public var STICK_L2(default,null) : AnalogStick = { x:0, y:null };
    //public var STICK_R2(default,null) : AnalogStick = { x:0, y:null };
    public var L2(default,null) = 0.0;
    public var R2(default,null) = 0.0;

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

            //trace( device.buttons.length );

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

            //trace( device.axes[2] );
            //var moved = new Array<>();

            var _STICK_L : AnalogStick = { x: device.axes[0], y: device.axes[1] };
            if( _STICK_L.x != STICK_L.x || _STICK_L.y != STICK_L.y ) {
                STICK_L.x = _STICK_L.x;
                STICK_L.y = _STICK_L.y;
                onStick( 'L', STICK_L );
            }
            var _STICK_R : AnalogStick = { x: device.axes[3], y: device.axes[4] };
            if( _STICK_R.x != STICK_R.x || _STICK_R.y != STICK_R.y ) {
                STICK_R.x = _STICK_R.x;
                STICK_R.y = _STICK_R.y;
                onStick( 'R', STICK_R );
            }

            /*
            var _STICK_L2 : AnalogStick = { x: device.axes[2], y: null };
            if( _STICK_L2.x != _STICK_L2.x ) {
                STICK_L2.x = _STICK_L2.x;
                onStick( 'L2', STICK_L2 );
            }
            var _STICK_R2 : AnalogStick = { x: device.axes[5], y: null };
            if( _STICK_R2.x != _STICK_R2.x ) {
                STICK_R2.x = _STICK_R2.x;
                onStick( 'R2', STICK_R2 );
            }
            * /
            trace(device.axes[5]);

            if( device.axes[5] != R2 ) {
                R2 = device.axes[5];
                onButtonPress( 'R2', R2 );
            }

            //for( stick in moved ) onButtonPress( btn );
        }
    }

    override function dispose() {
        devices = [];
    }

}
*/
