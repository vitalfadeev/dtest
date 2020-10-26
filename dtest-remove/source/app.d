import std.stdio;
import std.algorithm.mutation : remove;

void main()
{
	string[] s1;

    s1 = [ "a", "b", "c", "d", "e", "f" ];

    auto s2 = s1.remove!( a => a == "b" )();

    writefln( "s1 = %s", s1 );
    writefln( "s2 = %s", s2 );
}
