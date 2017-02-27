package haarp;

import electron.main.App;
import electron.main.BrowserWindow;
import electron.main.IpcMain;
import js.node.Net;

class Main {

    /*
    static function handleMessage(e,arg) {
        trace(e);
        trace(arg);
        e.sender.send( 'asynchronous-reply', 'pong' );
        //trace(data);
        //trace(data.test);
    }
    */

    static function openWindow( name : String ) : BrowserWindow {
        var win = new BrowserWindow( { width: 720, height: 480 } );
        win.on( closed, function(e) {
            if( js.Node.process.platform != 'darwin' )
                electron.main.App.quit();
        });
        win.loadURL( 'file://' + js.Node.__dirname + '/$name.html' );
        return win;
    }

    static function main() {

        trace( 'HAARP' );

        electron.main.App.on( 'ready', function(e) {

            //var project = new Project( 'HEAD-1', '0.0.1' );
            var project = { name: 'HEAD-1', version:'0.0.1' };

            IpcMain.on( 'asynchronous-message', function(e,a){
                trace(a);
                e.sender.send( 'asynchronous-reply', project );
            } );

            /*
            IpcMain.on( 'synchronous-message', function(e,a){
                trace( a );
                e.returnValue = 'pong';
            } );
            */

            var renderWindow = openWindow( 'render' );
        });
    }

}
