import std.stdio;
import std.algorithm.searching : find;


struct Classes
{
    string[] _classes;
    alias _classes this;


    T opBinary( string op: "in" )( T rhs )
    {
        return _classes.find( rhs );
    }
}


void main()
{
    Classes cs;

    cs ~= "box";
	writeln( cs._classes );

    auto res = "box" in cs;
    writeln( res );
}

