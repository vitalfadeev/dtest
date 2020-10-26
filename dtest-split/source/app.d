import std.stdio;
import std.algorithm, std.functional, std.range, std.stdio, std.string;
import std.ascii : isWhite;



void main()
{
    string s = "1px   2px 3px 4px";
    auto splits = s.split( " " );

	writefln( "%s", splits.length );
    writefln( "%s", splits );

    //
    auto splits2 = s.strip.splitter(" ").map!(a => a.splitter(" "));

    //writefln( "%s", splits2.length );
    writefln( "%s", splits2 );

    //
    writeln( "Learning    D is fun".split!isWhite.filter!(not!empty) ); // ["Learning", "D", "is", "fun"]
}
