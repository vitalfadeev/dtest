import std.math   : cos, sin, PI, PI_2, lrint;
import std.conv   : to;
import std.math   : rint;
import std.math   : isNaN;
import types      : POINT;
import circle     : CIRCLE;
import std.math   : round;
import std.format : format;
import std.stdio  : writeln;
import tools      : To;
import tools      : Writeln;
import math       : RoundedDiv;

alias typeof( POINT.x ) T;
alias typeof( precalculatedArray.length ) LengthT;

enum int PRECALCULATED_RADIUS = 1024;
enum int CURVE_LENGTH = 2 * 3 * PRECALCULATED_RADIUS / 4;

// For Radius = 1024
static POINT[ CURVE_LENGTH+1 ]  precalculatedArray;  // Length = 1024 * 2 * 3 * ( 4 Byte + 4 Byte ) / 4 + 1 = 12_288 + 1 Bytes
static ushort[ PRECALCULATED_RADIUS+1 ] precalculatedIndexX;  // Length = 1024 * ( 2 Byte ) + 1 = 2_048 + 1 Bytes
static ushort[ PRECALCULATED_RADIUS+1 ] precalculatedIndexY;  // Length = 1024 * ( 2 Byte ) + 1 = 2_048 + 1 Bytes


POINT[] GetPrecalculated() nothrow
{
    return precalculatedArray;
}


int GetPrecalculatedRadius()
{
    return PRECALCULATED_RADIUS;
}


void PreCalculate()
{
    POINT p;

    //precalculated = cast( POINT* ) stack_alloc( curveLength * POINT.sizeof );
    //precalculatedArray.reserve( CURVE_LENGTH );
    foreach ( i; 0 .. CURVE_LENGTH )
    {
        float radAngle = 1.0f * i * PI_2 / CURVE_LENGTH;

        p.x = to!T( rint( cos( radAngle ) * PRECALCULATED_RADIUS ) );
        p.y = to!T( rint( sin( radAngle ) * PRECALCULATED_RADIUS ) );

        precalculatedArray[ i ] = p;
        precalculatedIndexX[ p.x ] = i.to!ushort; // One X - many i. Saved last Biggest i.
        precalculatedIndexY[ p.y ] = i.to!ushort; // One X - many i. Saved last Biggest i.
    }
}


/**
 * angle: 0 .. CURVE_LENGTH == 0 .. 90
 */
auto PSin( uint angle )
{
    return precalculatedArray[ angle ].y;
}


/**
 * angle: 0 .. CURVE_LENGTH == 0 .. 90
 */
auto PCos( uint angle )
{
    return precalculatedArray[ angle ].x;
}


pragma( inline )
auto PX( uint angle )
{
    return precalculatedArray[ angle ].x;
}


pragma( inline )
auto PY( uint angle )
{
    return precalculatedArray[ angle ].y;
}


pragma( inline )
auto ReRadiusPX( int x, uint r )
{
    return r * x / PRECALCULATED_RADIUS;
}

pragma( inline )
auto ReRadiusPY( int y, uint r )
{
    return r * y / PRECALCULATED_RADIUS;
}

float FindAngle( CIRCLE circle, POINT point )
{
    // P3 | P4
    // ---+----
    // P2 | P1

    // 
    if ( point.x > circle.c.x )
    {
        //
        if ( point.y > circle.c.y )
        {
            // P1
            auto pCentered = point - circle.c;

            //
            auto i = Find( pCentered, circle.r );
        }
        else
        {
            // P4
        }
    }
    else
    {
        if ( point.y > circle.c.y )
        {
            // P2
        }
        else
        {
            // P3
        }
    }

    return 0;
}


pragma( inline )
LengthT Find( POINT p )
{
    // Find by X
    LengthT i = precalculatedIndexX[ p.x ];

    // Iterate by Y
    do
    {
        if ( precalculatedArray[ i ].y == p.y )
        {
            return i;
        }
        else
        {
            i--;
        }
    } while ( i >=0 && precalculatedArray[ i ].x == p.x );

    return i;
}


pragma( inline )
LengthT Find( POINT p, uint r )
{
    // ReRadius
    POINT pr = 
        POINT(
            p.x * r / PRECALCULATED_RADIUS,
            p.y * r / PRECALCULATED_RADIUS,
        );

    return Find( pr );
}


pragma( inline )
auto FindDirection( CIRCLE circle, POINT a, POINT b, POINT c )
{
    //
}


static this()
{
    PreCalculate();
}


// Round
//   / 4
//   each   4 / 2 = / 8
//   each   8 / 2 = / 16
//   each  16 / 2 = / 32
//   each  32 / 2 = / 64
//   each  64 / 2 = / 128
//   each 128 / 2 = / 256
//
//   each 256 / 2 = / 512
//   each 512 / 2 = / 1024
//
//   L = D * PI
//   L = 1024 * 3.14 = 3215.36
//
//   each 1024 / 2 = / 2048
//   each 2048 / 2 = / 4096
//                     4096 sections of Round
//
//      0 .. 1023 - 1 section ( S1 )        ---
//   1024 .. 2047 - 2 section ( S2 )  S3  /     \  S4
//   2048 .. 3071 - 3 section ( S3 )  S2  \     /  S1
//   3072 .. 4095 - 4 section ( S4 )        ---
//
//   ( 0,0 ) at top left corner. Because Human read from top left corner.
//   Positive values in S1 section.
//
//   Angle: 0 .. 4095
//
//
//   For font rendering...
//   For small size...
//   Angle    : 0 .. 255
//   R        : 0 .. 41  // R = L / PI / 2  = 255 / 3.14 / 2  = 81.21 / 2  = 40.61  = 41
//   x        : 0 .. 41
//   y        : 0 .. 41
//   fontSize : 0 .. 41
//
//   points[   0 ] = POINT(  RADIUS,  0       )
//   points[  64 ] = POINT(  0,       RADIUS  )
//   points[ 128 ] = POINT( -RADIUS,  0       )
//   points[ 192 ] = POINT(  0,      -RADIUS  )
//   points[ 256 ] = points[ 0 ]
//
//     0° = points[   0 ]
//    45° = points[  32 ]
//    90° = points[  64 ]
//   180° = points[ 128 ]
//   360° = points[   0 ]
//
//    30° = points[  21 ] // 30°  = 360 / 12  = 256 / 12  = 21.3
//    60° = points[  43 ] // 60°  = 360 /  6  = 256 /  6  = 42.6
//
//                                   S3    192    S4
//     0 ..  63 - 1 section ( S1 )         ---    
//    64 .. 127 - 2 section ( S2 )  128  /     \  255
//   128 .. 191 - 3 section ( S3 )  127  \     /    0
//   192 .. 255 - 4 section ( S4 )         ---    
//                                   S2     64    S1
//

struct PrecalculatedRound( T : byte )
{
    enum ushort LENGTH = 256;
    enum ubyte  RADIUS = round( 1.0f * LENGTH / PI / 2 ).to!ubyte; // 42

    enum Direction 
    {
        COLINEAR,
        CLOCK,
        UNCLOCK,
    }

    struct POINT 
    {
        // 64 bit total
        T x; // -127 .. 127
        T y; // -127 .. 127

        POINT opBinary( string op : "+" )( POINT b )
        {
            return POINT( x + b.x, y + b.y );
        }

        void opOpAssign( string op : "+" )( POINT b )
        {
            x += b.x;
            y += b.y;
        }
    }

    POINT[ LENGTH ] points;     // 256 * ( 1 + 1 )   =  512
    ubyte[ LENGTH ] indexes;    //                   =  256 
                                //                   =  768


    void InitPoints()
    {
        T x;
        T y;

        for ( ushort i = 0; i < LENGTH; i++ )
        {
            x = round( RADIUS * cos( 1.0f * i * PI * 2 / LENGTH ) ).to!( T );
            y = round( RADIUS * sin( 1.0f * i * PI * 2 / LENGTH ) ).to!( T );

            points[ i ].x = x;
            points[ i ].y = y;

            if ( x >= 0 )
            {
                if ( y > 0 )  // y from S1 and S2
                {
                    indexes[ x ] = i.to!ubyte;
                }
            }
            else // x < 0
            {
                if ( y >= 0 )
                {
                    indexes[ cast( ubyte ) x ] = i.to!ubyte;
                }
            }
        }
    }


    pragma( inline )
    ubyte GetAngle( T x, T y )
    {
        ubyte i;

        if ( x >= 0 )
        {
            i = indexes[ x ];

            if ( y >= 0 )
            {
                return i;  // from S1
            }
            else // y < 0
            {
                return ( 256 - i ).to!ubyte;  // from S4
                // may be... not i;
            }
        }
        else // x < 0
        {
            i = indexes[ cast( ubyte ) x ];

            if ( y >= 0 )
            {
                return i;  // from S2
            }
            else // y < 0
            {
                return ( 256 - i ).to!ubyte;  // from S3
                // may be... not i;
            }
        }
    }


    pragma( inline )
    int GetX( ushort a, uint r )
    {
        return ( cast( int ) r ) * points[ a ].x / RADIUS; 
    }


    pragma( inline )
    int GetY( ushort a, uint r )
    {
        return ( cast( int ) r ) * points[ a ].y / RADIUS; 
    }


    pragma( inline )
    POINT GetPoint( ushort a )
    {
        return points[ a ]; 
    }


    pragma( inline )
    POINT GetPoint( ushort a, uint r )
    {
        auto p = points[ a ];

        return 
            POINT( 
                RoundedDiv( ( cast( int ) r ) * p.x, RADIUS ).To!byte,  // * 10 / 10 for integer divide with round
                RoundedDiv( ( cast( int ) r ) * p.y, RADIUS ).To!byte
            ); 
    }


    pragma( inline )
    ubyte GetStep( uint r ) 
    {
        if ( r <= RADIUS )
            return ( round( RADIUS / r ) ).To!ubyte; 
        else
            return 1; 
    }


    Direction GetDirection( POINT a, POINT b, POINT c )
    {
        // From a to b, to c
        // See 10th slides from following link for derivation 
        // of the formula 
        int val = ( b.y - a.y ) * ( c.x - b.x ) - 
                  ( b.x - a.x ) * ( c.y - b.y ); 
      
        if ( val == 0 ) 
        {
            return Direction.COLINEAR;  // colinear 
        }
        else
        if ( val > 0 )
        {
            return Direction.CLOCK;
        }
        else
        {
            return Direction.UNCLOCK;
        }
    }


    void GetLengthArc( POINT a, POINT b, uint r, Direction direction )
    {
        //
    }
}


PrecalculatedRound!byte precalculatedRound;

static this()
{
    precalculatedRound.InitPoints();

    //assert( 0, 
    //    format!
    //        "LENGTH = %d, RADIUS = %d"
    //        ( precalculatedRound.LENGTH, precalculatedRound.RADIUS ) 
    //);
}

// pure nothrow @nogc



/*
 * Divide positive or negative dividend by positive divisor and round
 * to closest integer. Result is undefined for negative divisors and
 * for negative dividends if the divisor variable type is unsigned.
 */
auto DIV_ROUND_CLOSEST( T1, T2 )( T1 x, T2 divisor )
{                           
    auto __x = x;              
    auto __d = divisor;          

    return 
        ( 
            ( ( typeof ( x ) ) - 1 ) > 0 ||             
            ( ( typeof( divisor ) ) - 1 ) > 0 || 
            ( __x ) > 0 
        ) ?  
        ( ( ( __x ) + ( ( __d ) / 2 ) ) / ( __d ) ) :   
        ( ( ( __x ) - ( ( __d ) / 2 ) ) / ( __d ) );    
}                           


uint round_closest( uint dividend, uint divisor )
{
    return ( dividend + ( divisor / 2 ) ) / divisor;
}


int divRoundClosest( const int n, const int d )
{
  return 
    ( ( n < 0 ) ^ ( d < 0 ) ) 
    ? 
        ( ( n - d / 2 ) / d ) : 
        ( ( n + d / 2 ) / d );
}

