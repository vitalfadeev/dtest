import core.sys.windows.windows;
import std.stdio;
import std.stdio : writeln;
import mlmessage : mlMessage;

// angle -> x , y
HWND unoWindow;


void Do()
{
    import uno_window;

    unoWindow = CreateWindowUno();

    MainLoop();
}


void MainLoop()
{
    MSG msg;
    RECT vrect;

    while ( GetMessage( &msg, NULL, 0, 0 ) )
    {
        mlMessage = msg.message;
        writeln( "MainLoop(): ", msg.message );

        TranslateMessage( &msg );
        //DispatchMessage( &msg );
    }
}


void main()
{
    Do();
}
