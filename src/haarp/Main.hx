package haarp;

import js.Node;
import electron.main.App;
import electron.main.BrowserWindow;
import electron.main.IpcMain;
import electron.main.WebContents;
import Sys.println;

@cli({
    description: 'Mind bender',
    help: true
})
class Main implements om.CLI {

    @cli({
        name:  'vision',
        description: 'Set the vision to load',
        required: true
    })
    static function start( vision : String ) {

        println( '\033c\n  H  A  A  R  P   -   '+vision.toUpperCase() );

        var win = new BrowserWindow( {
            show: false,
            center: true,
            frame: #if debug true #else false #end,
            backgroundColor: '#000',
            webPreferences: {
                backgroundThrottling: false,
                devTools: #if debug true #else false #end
            }
        } );
        /*
        win.on( close, function(e) {
            trace('I do not want to be closed');
            e.returnValue = false;
        });
        */
        win.on( closed, function(e) {
            if( Node.process.platform != 'darwin' )
                electron.main.App.quit();
        });
        win.on( ready_to_show, function() {
            win.show();
        });
        win.webContents.on( did_finish_load, function() {
            #if debug
            win.webContents.openDevTools();
            #end
            /*
            //win.webContents.send( 'act', 'head-1' );
            IpcMain.on( 'synchronous-message', function(e,arg) {
                trace(arg);  // prints "ping"
                e.returnValue = 'pong';
            });
            */
        });
        win.loadURL( 'file://' + Node.__dirname + '/app.html' );
    }

    static function quit( ?info : String ) {
        if( info != null ) println( info );
        electron.main.App.quit();
    }

    static function exit( ?info : String, code = 0 ) {
        if( info != null ) println( info );
        electron.main.App.exit( code );
    }

    static function main() {

        electron.main.App.on( 'ready', function(e) {

            var args = Sys.args();
            var i = 0;
            while( i < args.length ) {
                var opt = args[i];
                switch opt {
                case '-help':
                    exit( 'Help yourself' );
                case '-version':
                    exit( 'v' + electron.main.App.getVersion() );
                case '-vision':
                    var vision = args[i+1];
                    if( vision == null )
                        exit( 'Missing vision to load', -1 );
                    //untyped electron.main.App.commandLine.appendSwitch( 'enable-web-bluetooth', true );
                    electron.main.Menu.setApplicationMenu( null );
                    start( vision );
                }
                i++;
            }
        });
    }

}
