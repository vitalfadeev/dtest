import std.stdio;

void main()
{
	wchar[] a;
    a = [ 'a', 'b', 'c' ];

    auto r = a[ 1 .. 2 ];

    r ~= 'd';

    writeln( r );
    writeln( a );
}
