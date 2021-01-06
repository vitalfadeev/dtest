import std.stdio;

void main()
{
    import std.utf;

    dstring dc1 = "\n".toUTF32;
    dstring dc2 = "\r\n".toUTF32;

	writeln( "dc1.length: ", dc1.length );
    writeln( "dc2.length: ", dc2.length );
   
    writeln( "dc1.toUTF8.length: ", dc1.toUTF8.length );
    writeln( "dc2.toUTF8.length: ", dc2.toUTF8.length );
}
