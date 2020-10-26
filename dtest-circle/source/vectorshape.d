module vectorshape;

import std.math     : PI;
import std.conv     : to;
import std.math     : rint;
import precalculate : GetPrecalculated;
import precalculate : GetPrecalculatedRadius;
import precalculate : PRECALCULATED_RADIUS;


void GetRoundedRectPoints( TPOINT )( int x, int y, int x2, int y2, int radiusTR, int radiusTL, int radiusBL, int radiusBR, uint smooth, ref TPOINT[] points )
{
    TPOINT[] tlCornerPoints;
    GetTopLeftCornerPoints!( TPOINT )( x + radiusTL, y + radiusTL, radiusTL, smooth, tlCornerPoints );
    
    TPOINT[] trCornerPoints;
    GetTopRightCornerPoints!( TPOINT )( x2 - radiusTR, y + radiusTR, radiusTR, smooth, trCornerPoints );

    TPOINT[] brCornerPoints;
    GetBottomRightCornerPoints!( TPOINT )( x2 - radiusBR, y2 - radiusBR, radiusBR, smooth, brCornerPoints );

    TPOINT[] blCornerPoints;
    GetBottomLeftCornerPoints!( TPOINT )( x + radiusBL, y2 - radiusBL, radiusBL, smooth, blCornerPoints );

    points = tlCornerPoints ~ trCornerPoints ~ brCornerPoints ~ blCornerPoints;
}


void GetTopLeftCornerPoints( TPOINT )( int cx, int cy, uint radius, uint smooth, ref TPOINT[] points )
{
    // cx     : center x
    // cy     : center y
    // radius : 0 .. 1000
    // smooth : 0 .. 100
    // points : POINT[ 0 .. $ ]

    //
    if ( radius == 0 )
    {
        points.length = 1;
        points[ 0 ].x = cx;
        points[ 0 ].y = cy;
        return;
    }

    //
    if ( radius == 1 )
    {
        points.length = 2;
        points[ 0 ].x = cx - radius;
        points[ 0 ].y = cy;
        points[ 1 ].x = cx;
        points[ 1 ].y = cy - radius;
        return;
    }

    //
    if ( smooth == 0 )
    {
        return;
    }

    if ( smooth < 1 )
        smooth = 1;

    if ( smooth > 100 )
        smooth = 100;

    //
    int segPointsCount;

    if ( radius == 2 )
    {
        segPointsCount = 1;
    }
    else 
    {
        int nativeSegPointsCount = 2 * 3 * radius / 4;
        int desmoothedSegPointsCount = nativeSegPointsCount * smooth / 100;
        segPointsCount = desmoothedSegPointsCount;

        if ( segPointsCount < 1)
            segPointsCount = 1;
    }

    //
    int pointsCount = segPointsCount;
    points.reserve( pointsCount + 1 );
    points.length = pointsCount + 1; // + last point

    //
    TPOINT* segPoint = points.ptr;

    //
    TPOINT* segMax = segPoint + segPointsCount;

    //
    segPoint.x = cx - radius;
    segPoint.y = cy;
    segPoint++;

    //
    auto precalculated = GetPrecalculated();
    auto precalcStep = precalculated.length / segPointsCount;

    auto pp = precalculated.ptr + precalcStep; // skip 0 point
    auto ppMax = precalculated.ptr + precalculated.length;

    //
    int nx, ny;

    // 
    for( ; ( segPoint < segMax ) && ( pp < ppMax ); segPoint++ )
    {
        nx = radius * pp.x / PRECALCULATED_RADIUS;
        ny = radius * pp.y / PRECALCULATED_RADIUS;

        segPoint.x = cx - nx;
        segPoint.y = cy - ny;

        //
        pp += precalcStep;
    }

    // last point
    segPoint.x = cx;
    segPoint.y = cy - radius;
}


void GetTopRightCornerPoints( TPOINT )( int cx, int cy, uint radius, uint smooth, ref TPOINT[] points )
{
    // cx     : center x
    // cy     : center y
    // radius : 0 .. 1000
    // smooth : 0 .. 100
    // points : POINT[ 0 .. $ ]

    //
    if ( radius == 0 )
    {
        points.length = 1;
        points[ 0 ].x = cx;
        points[ 0 ].y = cy;
        return;
    }

    //
    if ( radius == 1 )
    {
        points.length = 2;
        points[ 0 ].x = cx;
        points[ 0 ].y = cy - radius;
        points[ 1 ].x = cx + radius;
        points[ 1 ].y = cy;
        return;
    }

    //
    if ( smooth == 0 )
    {
        return;
    }

    if ( smooth < 1 )
        smooth = 1;

    if ( smooth > 100 )
        smooth = 100;

    //
    int segPointsCount;

    if ( radius == 2 )
    {
        segPointsCount = 1;
    }
    else 
    {
        int nativeSegPointsCount = 2 * 3 * radius / 4;
        int desmoothedSegPointsCount = nativeSegPointsCount * smooth / 100;
        segPointsCount = desmoothedSegPointsCount;

        if ( segPointsCount < 1)
            segPointsCount = 1;
    }

    //
    int pointsCount = segPointsCount;
    points.reserve( pointsCount + 1 );
    points.length = pointsCount + 1; // + last point

    //
    TPOINT* segPoint = points.ptr;

    //
    TPOINT* segMax = segPoint + segPointsCount;

    //
    segPoint.x = cx;
    segPoint.y = cy - radius;
    segPoint++;

    //
    auto precalculated = GetPrecalculated();
    auto precalcStep = precalculated.length / segPointsCount;

    auto pp = precalculated.ptr + precalcStep; // skip 0 point
    auto ppMax = precalculated.ptr + precalculated.length;

    //
    int nx, ny;

    // 
    for( ; ( segPoint < segMax ) && ( pp < ppMax ); segPoint++ )
    {
        nx = radius * pp.x / PRECALCULATED_RADIUS;
        ny = radius * pp.y / PRECALCULATED_RADIUS;

        segPoint.x = cx + ny;
        segPoint.y = cy - nx;

        //
        pp += precalcStep;
    }

    // last point
    segPoint.x = cx + radius;
    segPoint.y = cy;
}


void GetBottomRightCornerPoints( TPOINT )( int cx, int cy, uint radius, uint smooth, ref TPOINT[] points )
{
    // cx     : center x
    // cy     : center y
    // radius : 0 .. 1000
    // smooth : 0 .. 100
    // points : POINT[ 0 .. $ ]

    //
    if ( radius == 0 )
    {
        points.length = 1;
        points[ 0 ].x = cx;
        points[ 0 ].y = cy;
        return;
    }

    //
    if ( radius == 1 )
    {
        points.length = 2;
        points[ 0 ].x = cx + radius;
        points[ 0 ].y = cy;
        points[ 1 ].x = cx;
        points[ 1 ].y = cy + radius;
        return;
    }

    //
    if ( smooth == 0 )
    {
        return;
    }

    if ( smooth < 1 )
        smooth = 1;

    if ( smooth > 100 )
        smooth = 100;

    //
    int segPointsCount;

    if ( radius == 2 )
    {
        segPointsCount = 1;
    }
    else 
    {
        int nativeSegPointsCount = 2 * 3 * radius / 4;
        int desmoothedSegPointsCount = nativeSegPointsCount * smooth / 100;
        segPointsCount = desmoothedSegPointsCount;

        if ( segPointsCount < 1)
            segPointsCount = 1;
    }

    //
    int pointsCount = segPointsCount;
    points.reserve( pointsCount + 1 );
    points.length = pointsCount + 1; // + last point

    //
    TPOINT* segPoint = points.ptr;

    //
    TPOINT* segMax = segPoint + segPointsCount;

    //
    segPoint.x = cx + radius;
    segPoint.y = cy;
    segPoint++;

    //
    auto precalculated = GetPrecalculated();
    auto precalcStep = precalculated.length / segPointsCount;

    auto pp = precalculated.ptr + precalcStep; // skip 0 point
    auto ppMax = precalculated.ptr + precalculated.length;

    //
    int nx, ny;

    // 
    for( ; ( segPoint < segMax ) && ( pp < ppMax ); segPoint++ )
    {
        nx = radius * pp.x / PRECALCULATED_RADIUS;
        ny = radius * pp.y / PRECALCULATED_RADIUS;

        segPoint.x = cx + nx;
        segPoint.y = cy + ny;

        //
        pp += precalcStep;
    }

    // last point
    segPoint.x = cx;
    segPoint.y = cy + radius;
}


void GetBottomLeftCornerPoints( TPOINT )( int cx, int cy, uint radius, uint smooth, ref TPOINT[] points )
{
    // cx     : center x
    // cy     : center y
    // radius : 0 .. 1000
    // smooth : 0 .. 100
    // points : POINT[ 0 .. $ ]

    //
    if ( radius == 0 )
    {
        points.length = 1;
        points[ 0 ].x = cx;
        points[ 0 ].y = cy;
        return;
    }

    //
    if ( radius == 1 )
    {
        points.length = 2;
        points[ 0 ].x = cx;
        points[ 0 ].y = cy + radius;
        points[ 1 ].x = cx - radius;
        points[ 1 ].y = cy;
        return;
    }

    //
    if ( smooth == 0 )
    {
        return;
    }

    if ( smooth < 1 )
        smooth = 1;

    if ( smooth > 100 )
        smooth = 100;

    //
    int segPointsCount;

    if ( radius == 2 )
    {
        segPointsCount = 1;
    }
    else 
    {
        int nativeSegPointsCount = 2 * 3 * radius / 4;
        int desmoothedSegPointsCount = nativeSegPointsCount * smooth / 100;
        segPointsCount = desmoothedSegPointsCount;

        if ( segPointsCount < 1)
            segPointsCount = 1;
    }

    //
    int pointsCount = segPointsCount;
    points.reserve( pointsCount + 1 );
    points.length = pointsCount + 1; // + last point

    //
    TPOINT* segPoint = points.ptr;

    //
    TPOINT* segMax = segPoint + segPointsCount;

    //
    segPoint.x = cx;
    segPoint.y = cy + radius;
    segPoint++;

    //
    auto precalculated = GetPrecalculated();
    auto precalcStep = precalculated.length / segPointsCount;

    auto pp = precalculated.ptr + precalcStep; // skip 0 point
    auto ppMax = precalculated.ptr + precalculated.length;

    //
    int nx, ny;

    // 
    for( ; ( segPoint < segMax ) && ( pp < ppMax ); segPoint++ )
    {
        nx = radius * pp.x / PRECALCULATED_RADIUS;
        ny = radius * pp.y / PRECALCULATED_RADIUS;

        segPoint.x = cx - ny;
        segPoint.y = cy + nx;

        //
        pp += precalcStep;
    }

    // last point
    segPoint.x = cx - radius;
    segPoint.y = cy;
}


void GetCirclePoints( TPOINT )( int cx, int cy, uint radius, uint smooth, ref TPOINT[] points )
{
    // cx     : center x
    // cy     : center y
    // radius : 0 .. 1000
    // smooth : 0 .. 100
    // points : POINT[ 0 .. $ ]

    //
    if ( radius == 0 )
    {
        return;
    }

    //
    if ( radius == 1 )
    {
        points.length = 4;
        points[ 0 ].x = cx + radius;
        points[ 0 ].y = cy;
        points[ 1 ].x = cx;
        points[ 1 ].y = cy + radius;
        points[ 2 ].x = cx - radius;
        points[ 2 ].y = cy;
        points[ 3 ].x = cx;
        points[ 3 ].y = cy - radius;
        return;
    }

    //
    if ( smooth == 0 )
    {
        return;
    }

    if ( smooth < 1 )
        smooth = 1;

    if ( smooth > 100 )
        smooth = 100;

    //
    int segPointsCount;

    if ( radius == 2 )
    {
        segPointsCount = 1;
    }
    else 
    {
        int nativeSegPointsCount = 2 * 3 * radius / 4;
        int desmoothedSegPointsCount = nativeSegPointsCount * smooth / 100;
        segPointsCount = desmoothedSegPointsCount;

        if ( segPointsCount < 1)
            segPointsCount = 1;
    }

    //
    int pointsCount = 4 * segPointsCount;
    points.length = pointsCount;

    //
    TPOINT* seg1point = points.ptr;
    TPOINT* seg2point = seg1point + segPointsCount;
    TPOINT* seg3point = seg2point + segPointsCount;
    TPOINT* seg4point = seg3point + segPointsCount;

    TPOINT* seg2endPoint = seg2point + segPointsCount;
    TPOINT* seg4endPoint = seg4point + segPointsCount;

    //
    TPOINT* seg1Max = seg1point + segPointsCount;

    // 0 points: left, top, right, bottom
    seg1point.x = cx + radius;
    seg1point.y = cy;
    seg1point++;

    seg2point.x = cx;
    seg2point.y = cy + radius;
    seg2point++;

    seg3point.x = cx - radius;
    seg3point.y = cy;
    seg3point++;

    seg4point.x = cx;
    seg4point.y = cy - radius;
    seg4point++;

    //
    auto precalculated = GetPrecalculated();
    auto precalcStep = precalculated.length / segPointsCount;

    auto pp = precalculated.ptr + precalcStep; // skip 0 point
    auto ppMax = precalculated.ptr + precalculated.length;

    //
    int nx, ny;

    // 
    for( ; ( seg1point < seg1Max ) && ( pp < ppMax ); seg1point++, seg2point++, seg3point++, seg4point++ )
    {
        nx = radius * pp.x / PRECALCULATED_RADIUS;
        ny = radius * pp.y / PRECALCULATED_RADIUS;

        // 1/4 - bottom-right
        seg1point.x = cx + nx;
        seg1point.y = cy + ny;
        
        // 2/4 - bottom-left
        seg2point.x = cx - ny;
        seg2point.y = cy + nx;
        
        // 3/4 - top-left
        seg3point.x = cx - nx;
        seg3point.y = cy - ny;
        
        // 4/4 - top-right
        seg4point.x = cx + ny;
        seg4point.y = cy - nx;

        //
        pp += precalcStep;
    }
}
