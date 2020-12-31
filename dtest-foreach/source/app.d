import std.stdio;

void main()
{
    string chars = "Abcdef";
    size_t pos = 3;
    foreach_reverse ( i, c; chars[ 0 .. pos ] )
    {
        writeln( "i, c: ", i, ", ", c );
    }
}


