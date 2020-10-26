import std.math : round;


auto RoundedDiv( T1, T2 )( T1 a, T2 b )
    if ( __traits( isIntegral, T1 ) && __traits( isIntegral, T2 ) )
{
    T1 x = 10 * a / b;
    int d;
    
    d = x % 10;

    if ( d >= 5 )
    {
        x /= 10;
        x += 1;
    }
    else
    {
        x /= 10;    
    }

    return x;
}


// float
auto RoundedDiv( T1, T2 )( T1 a, T2 b )
    if ( __traits( isFloating, T1 ) && __traits( isFloating, T2 ) )
{
    return round( 1.0f * a / b ).to!T1;
}
