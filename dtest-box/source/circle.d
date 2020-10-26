import std.math : sqrt;
import std.math : rint;
import std.conv : to;
import types    : POINT;


struct CIRCLE
{
    POINT c;
    uint  r;
}


struct Circler
{
    POINT CenterFrom( int bx, int by, int cx, int cy ) 
    {
        int B = bx * bx + by * by;
        int C = cx * cx + cy * cy;
        int D = bx * cy - by * cx;

        return 
            POINT( 
                ( cy * B - by * C ) / ( 2 * D ), 
                ( bx * C - cx * B ) / ( 2 * D ) 
            );
    }


    uint Abs( POINT I )
    {
        return sqrt( 1.0f * ( I.x * I.x + I.y * I.y ) ).rint.to!uint;
    }


    CIRCLE CircleFrom( POINT A, POINT B, POINT C ) 
    {
        POINT I = CenterFrom( B.x - A.x, B.y - A.y, C.x - A.x, C.y - A.y );

        return 
            CIRCLE( 
                I + A, 
                Abs( I ) 
            );
    }
}


struct MidPointCircleDraw
{
    void Draw( POINT C, uint r )
    {
        int x = r;
        int y = 0; 
          
        // Printing the initial point on the axes  
        // after translation 
        PutPixel( x + C.x, y + C.y ); 
          
        // When radius is zero only a single 
        // point will be printed 
        if ( r > 0 ) 
        { 
            PutPixel(  x + C.x, -y + C.y ); 
            PutPixel(  y + C.x,  x + C.y ); 
            PutPixel( -y + C.x,  x + C.y ); 
        } 
          
        // Initialising the value of P 
        int P = 1 - r; 

        while ( x > y ) 
        {  
            y++; 
              
            // Mid-point is inside or on the perimeter 
            if ( P <= 0 ) 
                P = P + 2*y + 1; 
                  
            // Mid-point is outside the perimeter 
            else
            { 
                x--; 
                P = P + 2*y - 2*x + 1; 
            } 
              
            // All the perimeter points have already been printed 
            if ( x < y ) 
                break; 
              
            // Printing the generated point and its reflection 
            // in the other octants after translation 
            PutPixel(  x + C.x,  y + C.y ); 
            PutPixel( -x + C.x,  y + C.y ); 
            PutPixel(  x + C.x, -y + C.y ); 
            PutPixel( -x + C.x, -y + C.y ); 
              
            // If the generated point is on the line x = y then  
            // the perimeter points have already been printed 
            if ( x != y ) 
            { 
                PutPixel(  y + C.x,  x + C.y ); 
                PutPixel( -y + C.x,  x + C.y ); 
                PutPixel(  y + C.x, -x + C.y ); 
                PutPixel( -y + C.x, -x + C.y ); 
            } 
        }
    }


    void PutPixel( int x, int y )
    {
        //
    }
}


struct MidPointEllipseDraw
{
    void Draw( int rx, int ry, int xc, int yc ) 
    { 
        float dx, dy, d1, d2, x, y; 
        x = 0; 
        y = ry; 
      
        // Initial decision parameter of region 1 
        d1 = (ry * ry) 
             - (rx * rx * ry) 
             + (0.25 * rx * rx); 
        dx = 2 * ry * ry * x; 
        dy = 2 * rx * rx * y; 
      
        // For region 1 
        while (dx < dy) 
        { 
            // Print points based on 4-way symmetry 
            PutPixel(  x + xc,  y + yc ); 
            PutPixel( -x + xc,  y + yc ); 
            PutPixel(  x + xc, -y + yc ); 
            PutPixel( -x + xc, -y + yc ); 
      
            // Checking and updating value of 
            // decision parameter based on algorithm 
            if (d1 < 0) 
            { 
                x++; 
                dx = dx + (2 * ry * ry); 
                d1 = d1 + dx + (ry * ry); 
            } 
            else 
            { 
                x++; 
                y--; 
                dx = dx + (2 * ry * ry); 
                dy = dy - (2 * rx * rx); 
                d1 = d1 + dx - dy + (ry * ry); 
            } 
        } 
      
        // Decision parameter of region 2 
        d2 = ((ry * ry) * ((x + 0.5) * (x + 0.5))) 
             + ((rx * rx) * ((y - 1) * (y - 1))) 
             - (rx * rx * ry * ry); 
      
        // Plotting points of region 2 
        while ( y >= 0 ) 
        { 
            // printing points based on 4-way symmetry 
            PutPixel(  x + xc,  y + yc ); 
            PutPixel( -x + xc,  y + yc ); 
            PutPixel(  x + xc, -y + yc ); 
            PutPixel( -x + xc, -y + yc ); 
      
            // Checking and updating parameter 
            // value based on algorithm 
            if ( d2 > 0 ) { 
                y--; 
                dy = dy - (2 * rx * rx); 
                d2 = d2 + (rx * rx) - dy; 
            } 
            else 
            { 
                y--; 
                x++; 
                dx = dx + (2 * ry * ry); 
                dy = dy - (2 * rx * rx); 
                d2 = d2 + dx - dy + (rx * rx); 
            } 
        } 
    } 


    void PutPixel( float x, float y )
    {
        //
    }
}


struct FastMidPointEllipseDraw
{
    void Draw( int xm, int ym, int a, int b )
    {
        long x   = -a;
        long y   = 0; /* II. quadrant from bottom left to top right */
        long e2  = b;
        long dx  = ( 1 + 2*x ) * e2*e2; /* error increment */
        long dy  = x*x;
        long err = dx + dy; /* error of 1.step */
        long aa2 = a*a*2;
        long bb2 = b*b*2;

        do {
            PutPixel( xm-x, ym+y ); /* I. Quadrant */
            PutPixel( xm+x, ym+y ); /* II. Quadrant */
            PutPixel( xm+x, ym-y ); /* III. Quadrant */
            PutPixel( xm-x, ym-y ); /* IV. Quadrant */
            e2 = 2*err;
            if ( e2 >= dx ) { x++; err += dx += bb2; } /* x step */
            if ( e2 <= dy ) { y++; err += dy += aa2; } /* y step */
        } while ( x <= 0 );

        while ( y++ < b ) 
        { /* to early stop for flat ellipses with a=1, */
            PutPixel( xm, ym+y ); /* -> finish tip of ellipse */
            PutPixel( xm, ym-y );
        }
    }
 
    void PutPixel( Tx, Ty )( Tx x, Ty y )
    {
        //
    }   
}