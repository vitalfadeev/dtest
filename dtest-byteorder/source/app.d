import std.stdio;

int main()
{
    ushort x = 1; /* 0x0001 */

    writeln( *( cast( ubyte* ) &x )  ? "little-endian\n" : "big-endian\n" );

    return 0;
}