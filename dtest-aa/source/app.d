import std.stdio;

void main()
{
	bool[ string ][ int ] aa;

    aa[ 1 ][ "void*" ] = true;

    auto ptr = 1 in aa;

    writeln( *ptr );



    bool[ string ][ string ][ int ] aaa;

    aaa[ 1 ][ "object" ][ "method" ] = true;

    auto ptr1 = 1 in aaa;
    writeln( *ptr1 );

    foreach ( ref x; *ptr1 )
    {
        writeln( x );
    }

}
