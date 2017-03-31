package haarp.display;

@:enum abstract CompositeOperation(String) from String to String {
    var source_over = 'source-over';
    var source_in = 'source-in';
    var source_out = 'source-out';
    var source_atop = 'source-atop';
    var destination_over = 'destination-over';
    var destination_in = 'destination-in';
    var destination_out = 'destination-out';
    var destination_atop = 'destination-atop';
    var destination_lighter = 'destination-lighter';
    var copy = 'copy';
    var xor = 'xor';
    var multiply = 'multiply';
    var screen = 'screen';
    var overlay = 'overlay';
    var lighten = 'lighten';
    var color_dodge = 'color-dodge';
    var color_burn = 'color-burn';
    var hard_light = 'hard-light';
    var soft_light = 'soft-light';
    var difference = 'difference';
    var exclusion = 'exclusion';
    var hue = 'hue';
    var saturation = 'saturation';
    var color = 'color';
    var luminosity = 'luminosity';
}
