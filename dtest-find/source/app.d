import std.stdio;
import std.range;
import std.algorithm;

void main()
{
    string s = "Abc";

	auto r = s.find( "b" );

    writeln( r );
    writeln( typeof( r ).stringof );

    writeln( s.ptr );
    writeln( r.ptr );

    writeln( r.ptr - s.ptr );
    writeln( s.length - r.length );

    //
    r = s.find( "c" );

    writeln( r.ptr - s.ptr );
    writeln( s.length - r.length );

    //
    auto pos = s.retro.countUntil( "bc" );
    writeln( pos );
}
