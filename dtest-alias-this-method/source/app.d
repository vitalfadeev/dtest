import std.stdio;


struct Uno
{
    uint _w;

    void w( string s )
    {
        _w = 1;
    }
}


struct AppBar
{
    Uno uno;

    alias uno this;

    void w( string s )
    {
        _w = 2;
    }
}


void main()
{
	AppBar ab;
    
    ab.w = "100%";

    writeln( ab._w );

    ab.uno.w = "100%";

    writeln( ab._w );
}
