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
        button = [for(i in 0...15) false];
        axe = [for(i in 0...8) 0 ];
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
        }
    }

}
