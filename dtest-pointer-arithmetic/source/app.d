import std.stdio;


struct POINT
{
    int x;
    int y;
}


void main()
{
    POINT[] points;
    points = new POINT[ 100 ];

    POINT* p0 = points.ptr;

    POINT* p1 = p0;
    p1++;

    POINT* p2 = p0;
    p2++;
    p2++;

    writeln( "p0: ", p0 );
    writeln( "p1: ", p1 );
    writeln( "p2: ", p2 );
    writeln( "p2: ", p0 + 2 );
}
