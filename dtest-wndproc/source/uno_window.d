module uno_window;

import windows;
import core.sys.windows.windows;
static import winapi = core.sys.windows.windows;
import std.conv    : to;
import std.stdio : writeln;
import mlmessage : mlMessage;


extern (Windows)
LRESULT WinProcUno( HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam ) nothrow
{
    HDC hdc;
    PAINTSTRUCT ps;

    try {
        writeln( "WinProcUno(): ", message );
        if ( mlMessage != message )
            writeln( "NON QUEUE: ", message );
    }
    catch ( Throwable e )
    {
        //
    }

    switch ( message )
    {
        case WM_CREATE:
            return 0;            
            
        case WM_PAINT: {

            hdc = BeginPaint( hwnd, &ps );
            EndPaint( hwnd, &ps );

            //RECT irect;
            //GetClientRect( hwnd, &irect );
            //InvalidateRect( hwnd, &irect, 0 );

            return 0;
        }
            
        case WM_CLOSE: {
            PostQuitMessage( 0 );
            return 0;
        }
            
        default:
            return DefWindowProc( hwnd, message, wParam, lParam );
    }
}


HWND CreateWindowUno()
{
    WNDCLASS wc;

    _CreateClass( &WinProcUno, "Uno Circle", &wc );
    return _CreateWindow( "Uno Circle", 600, 310, 600, 300, &wc );
}

