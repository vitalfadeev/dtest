module uno_window;

import windows;
import core.sys.windows.windows;
import tools               : GET_X_LPARAM;
import tools               : GET_Y_LPARAM;
import windows             : _CreateClass;
import windows             : _CreateWindow;
import utf                 : toLPCWSTR;
import utf                 : towchar;
import std.container.dlist : DList;
import std.format          : format;
import std.math            : PI;
import std.algorithm       : find;
import std.math            : abs;
import std.math            : cos;
import std.math            : sin;
import std.math            : round;
import std.range           : assumeSorted;
import std.range           : empty;
import circle              : Circler;
import circle              : CIRCLE;
import precalculate        : PRECALCULATED_RADIUS;
import precalculate        : PX;
import precalculate        : PY;
import precalculate        : precalculatedRound;
import types               : POINT;
import tools               : To;
import tools               : Writefln;
import tools               : Writeln;


int xPos; 
int yPos;


extern (Windows)
LRESULT WinProcUno( HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam ) nothrow
{
    HDC hdc;
    PAINTSTRUCT ps;

    switch ( message )
    {
        case WM_CREATE: {
            return 0;            
        }
            
        case WM_PAINT: {

            hdc = BeginPaint( hwnd, &ps );
            
            // Rect
            int winWidth   = 600;
            int winHeight  = 300;
            int rectWidth  = 100;
            int rectHeight = 100;

            int left   = ( winWidth - rectWidth ) / 2;
            int top    = ( winHeight - rectHeight ) / 2;
            int right  = left + rectWidth;
            int bottom = top + rectHeight;

            Rectangle( hdc, left, top, right, bottom );

            // Symbol
            //RECT sRect = RECT( baselineX, baselineY, right, bottom );
            //DrawSymbol2( hdc, &sRect, "Arial", 12, "A" );

            // Box Symbol
            Box box;
            box.symbol = "B";
            box.fontFace = "arial";
            box.fontSize = 36;
            box.offsetLeft = left;
            box.offsetTop = top;
            box.lineHeight = box.fontSize;
            //
            box.DrawBaseLine( hdc );
            //
            box.DrawSymbol( hdc );

            //
            // DrawSpiro( hdc );
            Test1( hdc );

            //
            EndPaint( hwnd, &ps );

            return 0;
        }
            
        case WM_MOUSEMOVE: {
            xPos = GET_X_LPARAM( lParam ); 
            yPos = GET_Y_LPARAM( lParam );

            InvalidateRect( hwnd, NULL, 1 );
            
            return 0;
        }

        case WM_LBUTTONDOWN: {
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
    return _CreateWindow( "Test Animation", 600, 310, 600, 300, &wc );
}


void DrawSymbol2( HDC hdc, RECT* sRect, string fontFace, uint fontSize, string symbol ) nothrow
{
    int x = sRect.left;
    int y = sRect.top;

    LPCWSTR cstr = symbol.toLPCWSTR;

    UINT oldAlign = SetTextAlign( hdc, TA_BASELINE );

    //
    TextOutW( hdc, x, y, cstr, 1 ); 

    //
    SetTextAlign( hdc, oldAlign );
}


void SelectFont2( HDC hdc, string face, uint height )
{
    LOGFONTW lf;
    lf.lfHeight = height;
    lf.lfFaceName = face.towchar;

    auto font = CreateFontIndirectW( &lf );

    auto oldFont = SelectObject( hdc, font );

    //
    // DrawSymnol();

    //
    SelectObject( hdc, oldFont );
    DeleteObject( font );
}


// 
// Box
//   fontPointer
//   fontFace
//   fontSize
// 
// Font
//   refCount
//
// Fonts
//   Font .face .size
//   Font .face .size
//   Font .face .size

struct Font
{
    uint   refCount;
    string face;
    uint   size;
    HFONT  osFont;


    pragma( inline )
    void AddRef() nothrow
    {
        refCount++;
    }
}


struct Box
{
    Font*  fontPointer;
    string fontFace;
    uint   fontSize;
    string symbol;
    int    offsetLeft; // offset of the Document left-up corner
    int    offsetTop;  // offset of the Document left-up corner
    uint   lineHeight;


    void DrawSymbol( HDC hdc ) nothrow
    {
        SelectFont( hdc );
        DrawSymbol_( hdc );
    }


    pragma( inline )
    void SelectFont( HDC hdc ) nothrow
    {
        // Load Font if need
        if ( fontPointer is null )
        {
            if ( fonts.GetFont( fontFace, fontSize, &fontPointer ) == false )
            {
                assert( 0, "ERR: font not loaded: " ~ format!" %s, %s"( fontFace, fontSize ) );
            }
            else
            {
                fontPointer.AddRef();
            }
        }

        // Select Font
        SelectObject( hdc, fontPointer.osFont );
    }


    pragma( inline )
    void DrawSymbol_( HDC hdc ) nothrow
    {
        LPCWSTR cstr = symbol.toLPCWSTR;

        int x = offsetLeft - hdc.viewport.offsetLeft;
        int y = offsetTop  - hdc.viewport.offsetTop;

        TextOutW( hdc, x, y, cstr, 1 ); 
    }


    void DrawBaseLine( HDC hdc ) nothrow
    {
        auto hPen2 = CreatePen( PS_SOLID, 1, RGB ( 255, 0, 0 ) ) ;
        
        auto oldPen = SelectObject ( hdc, hPen2 );

        auto x = offsetLeft;
        auto y = offsetTop + lineHeight / 2;
        auto x2 = offsetLeft + 100;
        auto y2 = y;

        MoveToEx( hdc, x, y, NULL );
        LineTo( hdc, x2, y2 );

        SelectObject ( hdc, oldPen );

        DeleteObject ( hPen2 );
    }
}


struct Viewport
{
    int offsetLeft; // offset of the Document left-up corner
    int offsetTop;  // offset of the Document left-up corner
}


Fonts fonts;

struct Fonts
{
    DList!( Font* ) loadedFonts;


    bool GetFont( string face, uint size, Font** font ) nothrow
    {
        // foreach f in fonts
        //   return matched
        // else
        //   loadedFont = Load()
        //   return loadedFont

        // Check Exists
        if ( FindLoaded( face, size, font ) )
        {
            return true;
        }
        
        // Load New
        if ( Load( face, size, font ) )
        {
            return true;
        }

        // Fall
        return false;
    } 


    pragma( inline )
    bool FindLoaded( string face, uint size, Font** font ) nothrow
    {
        foreach ( ref f; loadedFonts )
        {
            if ( f.face == face && f.size == size )
            {
                *font = f;
                return true;
            }
        }

        return false;
    }


    pragma( inline )
    bool Load( string face, uint size, Font** font ) nothrow
    {
        LOGFONTW lf;
        lf.lfHeight = size;
        lf.lfFaceName[ 0 .. face.length ] = face.towchar;

        auto f = CreateFontIndirectW( &lf );

        // OK
        if ( f != NULL )
        {
            Font* newFont = new Font();

            newFont.face   = face;
            newFont.size   = size;
            newFont.osFont = f;

            loadedFonts ~= newFont;

            *font = newFont;

            return true;
        }

        // Fall
        return false;
    }
}


Viewport viewport( HDC hdc ) nothrow
{
    SIZE size;
    GetViewportExtEx( hdc, &size );
    return Viewport( size.cx, size.cy );
}


void DrawSpiro( HDC hdc, POINT A, POINT B, POINT C, POINT D ) nothrow
{
    // CIRCLE1 via ABC
    // CIRCLE2 via BCD
    // Spiro   via BC 

/*
    //
    CIRCLE circle1;
    CIRCLE circle2;

    try {
    circle1 = 
        Circler().CircleFrom( A, B, C );
    } catch ( Throwable e ) { assert( 0, e.toString() ); }

    try {
    circle2 = 
        Circler().CircleFrom( B, C, D );
    } catch ( Throwable e ) { assert( 0, e.toString() ); }

    //
    POINT C1 = POINT( circle1.c.x, circle1.c.y );
    int r1  = circle1.r;

    POINT C2 = POINT( circle2.c.x, circle2.c.y );
    int r2  = circle2.r;

    //
    //DrawCircle( hdc, C1, r1 );
    //DrawCircle( hdc, C2, r2 );

    //
    int x;
    int y;
    float t = 0;

    //
    MoveToEx( hdc, C1.x + r1, C1.y, NULL );

    // Spiro
    auto angle1 = FindAngle( C1, B );
    auto angle2 = FindAngle( C2, C );

    // Find Direction
    auto dir1 = FindDirection( C1, B, C );

    // 

    for ( int a = 0; a <= CURVE_LENGTH; a++, t = 1.0f * a / CURVE_LENGTH ) 
    {
        float deltaR = 1.0f * ( r2 - r1 );
        float newR = r1 + deltaR * t;

        float deltaCx = 1.0f * ( C2.x - C1.x ) * t;
        float newCx = 0.0f + C1.x + deltaCx;

        float deltaCy = 1.0f * ( C2.y - C1.y ) * t;
        float newCy = 0.0f + C1.y + deltaCy;

        Writefln( "" );
        Writefln( "t      : %f", t );
        Writefln( "deltaR : %f", deltaR );
        Writefln( "newCy  : %s", newCy );
        Writefln( "newR   : %s", newR );
        Writefln( "sin(a) : %s", sin( a ) );

        x = PX( a );
        y = PY( a );

        LineTo( hdc, x, y );
        //DrawCircle( hdc, POINT( x, y ), abs( newR ).To!int );
    }
  */
}


void DrawCircleSinCos( HDC hdc, POINT C, uint r ) nothrow
{
    int x;
    int y;
    COLORREF color = RGB( 0xFF, 0, 0 );

    // Segments

    //
    // 1
    // Start Point
    //MoveToEx( hdc, C.x + r, C.y, NULL );

    for ( float a = 0; a < PI*2; a += PI / 100 ) 
    {
        x = round( 1.0 * C.x + r * cos( a ) ).To!int;
        y = round( 1.0 * C.y + r * sin( a ) ).To!int;

        //LineTo( hdc, x, y );
        SetPixel( hdc, x, y, color );
    }

    // Last segment
    //LineTo( hdc, C.x + r, C.y );
}


void DrawCirclePrecalculated( HDC hdc, POINT C, uint r ) nothrow
{
    int x;
    int y;

    // Start Point
    MoveToEx( hdc, C.x + r, C.y, NULL );

    ubyte step = precalculatedRound.GetStep( r );

    COLORREF color = RGB( 0, 0, 0 );
    POINT p;

    for ( ushort a = 0; a < precalculatedRound.LENGTH; a += step ) 
    {
        p = C;
        p += precalculatedRound.GetPoint( a, r );

        x = ( p.x ).To!int;
        y = ( p.y ).To!int;

        //LineTo( hdc, x, y );
        SetPixel( hdc, x, y, color );
    }
}


void DrawCircleMidpoint( HDC hdc, POINT C, uint r ) nothrow
{
    int x = r;
    int y = 0; 

    COLORREF color = RGB( 0, 0xFF, 0 );
      
    // Printing the initial point on the axes  
    // after translation 
    SetPixel( hdc, x + C.x, y + C.y, color ); 
      
    // When radius is zero only a single 
    // point will be printed 
    if ( r > 0 ) 
    { 
        SetPixel( hdc,  x + C.x, -y + C.y, color ); 
        SetPixel( hdc,  y + C.x,  x + C.y, color ); 
        SetPixel( hdc, -y + C.x,  x + C.y, color ); 
    } 
      
    // Initialising the value of P 
    int P = 1 - r; 

    while ( x > y ) 
    {  
        y++; 
          
        // Mid-point is inside or on the perimeter 
        if ( P <= 0 ) 
        {
            P = P + 2*y + 1; 
        }     
        // Mid-point is outside the perimeter 
        else
        { 
            x--; 
            P = P + 2*y - 2*x + 1; 
        } 
          
        // All the perimeter points have already been printed 
        if ( x < y ) 
        {
            break; 
        }
          
        // Printing the generated point and its reflection 
        // in the other octants after translation 
        SetPixel( hdc,  x + C.x,  y + C.y, color ); 
        SetPixel( hdc, -x + C.x,  y + C.y, color ); 
        SetPixel( hdc,  x + C.x, -y + C.y, color ); 
        SetPixel( hdc, -x + C.x, -y + C.y, color ); 
          
        // If the generated point is on the line x = y then  
        // the perimeter points have already been printed 
        if ( x != y ) 
        { 
            SetPixel( hdc,  y + C.x,  x + C.y, color ); 
            SetPixel( hdc, -y + C.x,  x + C.y, color ); 
            SetPixel( hdc,  y + C.x, -x + C.y, color ); 
            SetPixel( hdc, -y + C.x, -x + C.y, color ); 
        } 
    }
}


void DrawCircle( HDC hdc, CIRCLE circle ) nothrow
{
    DrawCircleSinCos        ( hdc, POINT( circle.c.x, circle.c.y ), circle.r );
    DrawCircleMidpoint      ( hdc, POINT( circle.c.x, circle.c.y ), circle.r );
    DrawCirclePrecalculated ( hdc, POINT( circle.c.x, circle.c.y ), circle.r );
}


void DrawControlPoint( HDC hdc, POINT p ) nothrow
{
    DrawCircle( hdc, CIRCLE( p, 3 ) );
}


void Test1( HDC hdc ) nothrow
{
    POINT C1 = POINT( 200, 200 );
    int r1  = 50;

    int r2  = 25;
    POINT C2 = POINT( C1.x - r1 + r2, C1.y );

    POINT[] points;

    points ~= POINT( C1.x + r1, C1.y );         // 0
    points ~= POINT( C1.x     , C1.y + r1 );    // 1
    points ~= POINT( C1.x - r1, C1.y );         // 2

    points ~= POINT( C2.x     , C2.y - r2 );    // 3
    points ~= POINT( C2.x + r2, C2.y );         // 4

    //
    foreach( cp; points )
    {
        DrawControlPoint( hdc, cp );
    }

    //
    DrawCircle( hdc, CIRCLE( C1, r1 ) );
    DrawCircle( hdc, CIRCLE( C2, r2 ) );

    //
    CIRCLE circle;

    // 1
    try {
    circle = 
        Circler().CircleFrom( points[ 0 ], points[ 1 ], points[ 2 ] );
    } catch ( Throwable e ) { assert( 0, e.toString() ); }

    //
    DrawCircle( hdc, circle );

    // 2
    try {
    circle = 
        Circler().CircleFrom( points[ 2 ], points[ 3 ], points[ 4 ] );
    } catch ( Throwable e ) { assert( 0, e.toString() ); }

    //
    DrawCircle( hdc, circle );

    // Red
    auto hPen2  = CreatePen( PS_SOLID, 1, RGB ( 255, 0, 0 ) ) ;    
    auto oldPen = SelectObject ( hdc, hPen2 );


    // Spiro
    DrawSpiro( 
        hdc, 
        points[ 0 ],
        points[ 1 ],
        points[ 2 ],
        points[ 3 ]
    );

    //DrawSpiro( 
    //    hdc, 
    //    points[ 1 ],
    //    points[ 2 ],
    //    points[ 3 ],
    //    points[ 4 ]
    //);

    // Restore Color
    SelectObject ( hdc, oldPen );
    DeleteObject ( hPen2 );
}
