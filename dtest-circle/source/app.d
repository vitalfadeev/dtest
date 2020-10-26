import core.sys.windows.windows;
import std.stdio;
import point : POINT;
import precalculate : PreCalculate;


// angle -> x , y
HWND gdiWindow;
HWND unoWindow;

/*
void* stack_alloc( int length )
{
    void* ptr = alloca( length );
    return ptr;
}
*/

/*
void* gc_alloc( int length )
{
    // new POINT[ length ]
    void* ptr = GC.malloc( length );
    return ptr;
}
*/


void Do()
{
    // create window 1 - top
    // create window 2 - bottom
    // create thread 1 - paint gdi.circle
    // create thread 2 - paint uno.circle
    // update windows
    import gdi_window;
    import uno_window;

    gdiWindow = CreateWindowGDI();
    unoWindow = CreateWindowUno();

    MainLoop();
}


void MainLoop()
{
    MSG msg;
    RECT vrect;

    while ( GetMessage( &msg, NULL, 0, 0 ) )
    {
        TranslateMessage( &msg );
        DispatchMessage( &msg );                        
    }
}


void main()
{
    PreCalculate();

    Do();
}
