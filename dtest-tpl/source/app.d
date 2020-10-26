import std.stdio;


template t()
{
    int _x;
    
    int x()
    {
        return _x;
    }

    void x( int v )
    {
        _x = v;
    }
}


void main()
{
    t!().x = 1;
    
	writeln( t!().x );
}
