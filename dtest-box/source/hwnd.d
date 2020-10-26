static import winapi = core.sys.windows.windows;
import core.sys.windows.windows : PAINTSTRUCT;
import core.sys.windows.windows : RECT;
import core.sys.windows.windows : BOOL;
import core.sys.windows.windows : UINT;
import core.sys.windows.windows : LPARAM;
import core.sys.windows.windows : WPARAM;
import HDC;


struct HWND
{
    winapi.HWND hwnd;


pragma( inline ):
    //HDC BeginPaint( PAINTSTRUCT* ps ) { return cast( HDC ) winapi.BeginPaint( hwnd, ps ); }

    alias winapi.BeginPaint     BeginPaint;
    alias winapi.EndPaint       EndPaint;
    alias winapi.InvalidateRect InvalidateRect;
    alias winapi.DefWindowProc  DefWindowProc;
    alias winapi.ShowWindow     ShowWindow;
    alias winapi.UpdateWindow   UpdateWindow;
}

