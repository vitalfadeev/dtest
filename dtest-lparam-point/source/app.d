import std.stdio;

import core.sys.windows.windows : LOWORD, HIWORD, LRESULT, WPARAM, LPARAM;


int GET_X_LPARAM( LPARAM lp )
{
    return cast( int ) cast( short )LOWORD( lp );
}


int GET_Y_LPARAM( LPARAM lp )
{
    return cast( int ) cast( short )HIWORD( lp );
}

struct POINT 
{
    int x;
    int y;
}


POINT toPOINT( LPARAM lParam )
{
    return POINT( GET_X_LPARAM( lParam ), GET_Y_LPARAM( lParam ) );
}


void main()
{
    LPARAM lParam = 0x00_01_00_02;

    int mx = GET_X_LPARAM( lParam );
    int my = GET_Y_LPARAM( lParam );

	writefln( "x: %d, y: %d", mx, my );

    //
    POINT* p = cast( POINT* ) &lParam;
    writefln( "x: %d, y: %d", p.x, p.y );

    //
    POINT p2 = lParam.toPOINT;
    writefln( "x: %d, y: %d", p2.x, p2.y );
}
