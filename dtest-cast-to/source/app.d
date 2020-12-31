import core.sys.windows.windows;
import std.stdio;

pragma( lib, "user32.lib" );


struct Rect
{
    RECT native;    
    alias native this;
}


void main()
{
    Rect rect;
    POINT p;
	PtInRect( &rect.native, p );

    uint  i = 1;
    ulong l = cast( ulong ) i ;
    writeln( "i: ", i );
    writeln( "l: ", l );

    ulong l2 = 1;
    uint  i2 = cast( uint ) l2;
    writeln( "i2: ", i2 );
    writeln( "l2: ", l2 );

    ulong l3 = 0x100000000000;
    uint  i3 = cast( uint ) l3;
    writeln( "i3    : ", i3 );
    writeln( "l3: ", l3 );

    uint a = 5;
    uint b = 2;
    writeln( cast( float ) a / b );
}
