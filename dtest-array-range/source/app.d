import std.stdio;
import std.container.array;
import std.array;


void main()
{
    uint[] b;
    b = [ 1, 2, 3, 4, 5 ];

    b.replaceInPlace( 1, 2, [ 0, 1, 1, 1, 1 ] );

    writeln( b );

    //
    Array!uint a;
    a.insertBack( 1 );
    a.insertBack( 2 );
    a.insertBack( 3 );

    a.Range r;

	writeln( a );
    writeln( r );

}
