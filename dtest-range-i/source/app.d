import std.stdio;

void main()
{
	string a = "abcdef";

    foreach ( i, c; a[ 3 .. $ ] )
    {
        writeln( "i:", i, ", c: ", c );
    }
}
