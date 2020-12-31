import std.stdio;


struct Percent
{
    uint a;
    alias a this;
}

pragma( inline )
Percent percent( uint a )
{
    return cast( Percent ) a ;
}


struct Px
{
    uint a;
    alias a this;
}

pragma( inline )
Px px( uint a )
{
    return cast( Px ) a;
}


enum ValueType
{
    Undefined,
    //Int,
    //Float,
    //String,
    Px,
    Percent,
    Inherit,
}


struct Value
{
    ValueType type = ValueType.Undefined;
    union
    {
        int           pxValue;
        uint          percentValue;
        string        stringValue;
    }


    void opAssign( Percent a )
    {
        type         = ValueType.Percent;
        percentValue = a;
    }


    void opAssign( Px a )
    {
        type    = ValueType.Px;
        pxValue = a;
    }
}




void main()
{
	Value width;

    width = 100.px;
    writeln( width );

    width = 100.percent;
    writeln( width );
}
