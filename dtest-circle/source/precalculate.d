module precalculate;

import std.math : cos, sin, PI, PI_2, lrint;
import std.conv : to;
import point    : POINT;
import std.math : rint;
import std.math : isNaN;

static POINT[] precalculated;

enum int PRECALCULATED_RADIUS = 1024;


POINT[] GetPrecalculated() nothrow
{
    return precalculated;
}


int GetPrecalculatedRadius()
{
    return PRECALCULATED_RADIUS;
}


void PreCalculate()
{
    POINT p;
    
    int curveLength = 2 * 3 * PRECALCULATED_RADIUS / 4;

    //precalculated = cast( POINT* ) stack_alloc( curveLength * POINT.sizeof );
    precalculated.reserve( curveLength );

    foreach ( i; 0 .. curveLength )
    {
        float radAngle = 1.0f * i * PI_2 / curveLength;

        p.x = to!int( rint( cos( radAngle ) * PRECALCULATED_RADIUS ) );
        p.y = to!int( rint( sin( radAngle ) * PRECALCULATED_RADIUS ) );

        precalculated ~= p;
    }
}

