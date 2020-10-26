module uno_window;

import windows;
import core.sys.windows.windows;
static import winapi = core.sys.windows.windows;
import std.conv    : to;
import point       : POINT;
import vectorshape : GetCirclePoints;
import vectorshape : GetRoundedRectPoints;


// BeginPath
// MoveToEx
// PolylineTo
// CloseFigure
// EndPath
// FillPath


void PaintPath( TPOINT )( HDC hdc, TPOINT[] points )
{
    //
    //HPEN hPenOld;
    //HPEN hLinePen;
    //COLORREF qLineColor;
    //qLineColor = RGB( 255, 0, 0 );
    //hLinePen = CreatePen( PS_SOLID, 1, qLineColor );
    //hPenOld = cast( HPEN ) SelectObject( hdc, hLinePen );

    auto brush = CreateSolidBrush( RGB( 0x88, 0xAA, 0xCC ) );
    auto oldbrush = SelectObject( hdc, brush );

    //
    BeginPath( hdc );
    MoveToEx( hdc, points[0].x, points[0].y, NULL );
    PolylineTo( hdc, points.ptr, to!int( points.length ) );
    //LineTo( hdc, points[0].x, points[0].y );
    CloseFigure( hdc );
    EndPath( hdc );
    FillPath( hdc );
    //StrokePath( hdc );
    //StrokeAndFillPath( hdc );
    //SelectClipPath( hdc, RGN_COPY );

    //
    //SelectObject( hdc, hPenOld );
    //DeleteObject( hLinePen );    

    //
    SelectObject( hdc, oldbrush );
    DeleteObject( brush );    
}


/*
void PaintUnoCircle( HDC hdc, HWND hwnd, int cx, int cy, uint radius=50, uint smooth=10 )
{
    // cx     : center x
    // cy     : center y
    // radius : 0 .. 1000
    // smooth : 0 .. 100

    //
    if ( radius == 0 )
    {
        return;
    }

    //
    if ( radius == 1 )
    {
        // DrawPoint( cx, cy );
        // DrawPoint( cx, cy );
        // DrawPoint( cx, cy );
        // DrawPoint( cx, cy );
        return;
    }

    //
    if ( radius == 2 )
    {
        // DrawPoint( cx, cy );
        // DrawPoint( cx, cy );
        // DrawPoint( cx, cy );
        // DrawPoint( cx, cy );
        // DrawPoint( cx, cy );
        // DrawPoint( cx, cy );
        // DrawPoint( cx, cy );
        // DrawPoint( cx, cy );
        return;
    }

    //
    if ( smooth == 0 )
    {
        return;
    }

    if ( smooth < 1 )
        smooth = 1;

    if ( smooth > 100 )
        smooth = 100;

    //
    int nativeSegPointsCount = 2 * 3 * radius / 4;
    int desmoothedSegPointsCount = nativeSegPointsCount * smooth / 100;
    int segPointsCount = desmoothedSegPointsCount;

    if ( segPointsCount < 1 )
    {
        // DrawPoint( cx, cy );
        return;
    }

    //
    winapi.POINT[] points;
    int pointsCount = 4 * segPointsCount;
    points = new winapi.POINT[ pointsCount ];

    //
    winapi.POINT* seg1point = points.ptr;
    winapi.POINT* seg2point = seg1point + segPointsCount;
    winapi.POINT* seg3point = seg2point + segPointsCount;
    winapi.POINT* seg4point = seg3point + segPointsCount;

    winapi.POINT* seg2endPoint = seg2point + segPointsCount;
    winapi.POINT* seg4endPoint = seg4point + segPointsCount;

    //
    winapi.POINT* seg1Max = seg1point + segPointsCount;

    // 0 points: left, top, right, bottom
    seg1point.x = cx + radius;
    seg1point.y = cy;
    seg1point++;

    seg2point.x = cx;
    seg2point.y = cy + radius;
    seg2endPoint--;

    seg3point.x = cx - radius;
    seg3point.y = cy;
    seg3point++;

    seg4point.x = cx;
    seg4point.y = cy - radius;
    seg4endPoint--;

    //
    auto precalculated = GetPrecalculated();
    auto precalcStep = precalculated.length / segPointsCount;

    POINT* pp = precalculated.ptr + precalcStep; // skip 0 point
    POINT* ppMax = precalculated.ptr + precalculated.length;

    //
    int nx, ny;

    // 
    for( ; ( seg1point < seg1Max ) && ( pp < ppMax ); seg1point++, seg2endPoint--, seg3point++, seg4endPoint-- )
    {
        nx = radius * pp.x / PRECALCULATED_RADIUS;
        ny = radius * pp.y / PRECALCULATED_RADIUS;

        // 1/4
        seg1point.x = cx + nx;
        seg1point.y = cy + ny;
        
        // 2/4
        seg2endPoint.x = cx - nx;
        seg2endPoint.y = cy + ny;
        
        // 3/4
        seg3point.x = cx - nx;
        seg3point.y = cy - ny;
        
        // 4/4
        seg4endPoint.x = cx + nx;
        seg4endPoint.y = cy - ny;

        //
        pp += precalcStep;
    }

    //
    HPEN hPenOld;
    HPEN hLinePen;
    COLORREF qLineColor;
    qLineColor = RGB( 255, 0, 0 );
    hLinePen = CreatePen( PS_SOLID, 1, qLineColor );
    hPenOld = cast( HPEN ) SelectObject( hdc, hLinePen );

    //
    MoveToEx( hdc, points[0].x, points[0].y, NULL );
    PolylineTo( hdc, points.ptr, pointsCount );
    LineTo( hdc, points[0].x, points[0].y );

    //
    SelectObject( hdc, hPenOld );
    DeleteObject( hLinePen );
}
*/




static int xOffset = 0;
static int counter = 0;

extern (Windows)
LRESULT WinProcUno( HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam ) nothrow
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

            counter++;
            if ( counter > 1000 )
            {
                counter = 1;
                //xOffset++;
            }

            try 
            {
                int cx = 125;
                int cy = 125;
                int smooth = 100;
                int raduis = 5;
                int rectCornerRadius = 5;
                int rectGrow = 50;

                winapi.POINT[] points;
                GetCirclePoints!( winapi.POINT )( cx + xOffset, cy, raduis, smooth, points );

                if ( points )
                {
                    PaintPath( hdc, points );
                }

                //
                winapi.POINT[] roundedRectPoints;
                GetRoundedRectPoints!( winapi.POINT )( 
                    cx - ( rectCornerRadius + rectGrow ), 
                    cy - ( rectCornerRadius + rectGrow ), 
                    cx + ( rectCornerRadius + rectGrow ), 
                    cy + ( rectCornerRadius + rectGrow ), 
                    rectCornerRadius, 
                    rectCornerRadius, 
                    0, 
                    0, 
                    smooth, 
                    roundedRectPoints 
                );

                if ( points )
                {
                    PaintPath( hdc, roundedRectPoints );
                }

            }
            catch ( Throwable e )
            {
                assert( 0, e.toString() );
            }


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
    return _CreateWindow( "Uno Circle", 0, 310, 1000, 300, &wc );
}

