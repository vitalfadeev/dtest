import std.stdio;
import std.format : format;

public import core.sys.windows.windows : COLORREF;


void main()
{
    struct COLOR
    {
        union
        {
            COLORREF valueNative; // ABGR
            struct
            {
                //ubyte a; // d
                //ubyte b; // c
                //ubyte c; // b
                //ubyte d; // a
                ubyte r; 
                ubyte g;
                ubyte b;
                ubyte a;
            }
        }

        // a a d r
        // b b c g
        // c g b b
        // d r a a


        string toString()
        {
            return format!"Color( #%02x%02x%02x.%02x )"( r, g, b, a );
        }
    }


    COLORREF RGB( uint v ) 
    {
        //uint  a = ( v & 0xFF000000 );
        ubyte r = ( v & 0xFF0000 ) >> 16;
        ubyte g = ( v & 0x00FF00 ) >> 8;
        ubyte b = ( v & 0x0000FF );
        
        //return ( a | ( b << 16 ) | ( g << 8 ) | r ); // ABGR
        return ( ( b << 16 ) | ( g << 8 ) | r ); // ABGR
    }


	writeln( COLOR( 0xAABBCCDD ) );
    writefln( "%X", COLOR( 0xAABBCCDD ).valueNative );
    
    writefln( "RGB: %s", COLOR( RGB( 0xAABBCC ) ) );
    writefln( "RGB.n: %X", COLOR( RGB( 0xAABBCC ) ).valueNative );

    writeln( COLOR( RGB( 0xAABBCCDD ) ) );
    writefln( "%X", COLOR( RGB( 0xAABBCCDD ) ).valueNative );
}

