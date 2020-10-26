module gdi_window;

import windows;
import core.sys.windows.windows;


void PaintGDI( HDC hdc, HWND hwnd ) nothrow
{
    static int xOffset = 0;
    static int counter = 0;

    counter++;
    if ( counter > 1000 )
    {
        counter = 1;
        xOffset++;
    }

    int left = 75 + xOffset;
    int top = 75;
    int right = 175 + xOffset;
    int bottom = 175;

    SelectObject( hdc, GetStockObject( HOLLOW_BRUSH ) ); 

    HPEN hPenOld;
    HPEN hLinePen;
    COLORREF qLineColor;
    qLineColor = RGB( 255, 0, 0 );
    hLinePen = CreatePen( PS_SOLID, 1, qLineColor );
    hPenOld = cast( HPEN ) SelectObject( hdc, hLinePen );

    Ellipse( hdc, left, top, right, bottom ); 

    SelectObject( hdc, hPenOld );
    DeleteObject( hLinePen );
}


extern (Windows)
LRESULT WinProcGDI( HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam ) nothrow
{
    HDC hdc;
    PAINTSTRUCT ps;

    switch ( message )
    {
        case WM_CREATE:
            return 0;
            
        case WM_HOTKEY: {
            return 0;
        }
            
        case WM_PAINT: {

            hdc = BeginPaint( hwnd, &ps );

            PaintGDI( hdc, hwnd );

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


HWND CreateWindowGDI()
{
    WNDCLASS wc;

    _CreateClass( &WinProcGDI, "GDI Circle", &wc );
    return _CreateWindow( "GDI Circle", 0, 0, 1000, 300, &wc );
}


