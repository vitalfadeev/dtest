static import winapi=core.sys.windows.windows;
import precalculate : precalculatedRound;

alias precalculatedRound.POINT pPOINT;


struct POINT
{
    int x;
    int y;

    POINT opBinary( string op: "-" )( POINT b )
    {
        return POINT( x - b.x, y - b.y );
    }


    POINT opBinary( string op: "+" )( POINT b )
    {
        return POINT( x + b.x, y + b.y );
    }


    bool opEquals( POINT b )
    {
        return ( x == b.x ) && ( y == b.y );
    }


    void opOpAssign( string op : "+" )( POINT b )
    {
        x += b.x;
        y += b.y;
    }


    void opOpAssign( string op : "+" )( pPOINT b )
    {
        x += b.x;
        y += b.y;
    }
}

