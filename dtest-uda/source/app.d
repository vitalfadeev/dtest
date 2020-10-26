import std.stdio;


struct Element {
    int color;


    void onClick()
    {
        //
    }
}


struct Color
{
    enum ValueType
    {
        UNDEFINED,
        INT,
        STRING,
    }

    ValueType type;
    union 
    {
        int    valueInt;
        string valueString;
    }

    this( int v )
    {
        type = ValueType.INT;
        valueInt = v;
    }


    this( string v )
    {
        type = ValueType.STRING;
        valueString = v;
    }
};


struct Stru
{
    void* parent;

    void onClick()
    {
        //
    }
}


void main()
{
	@Element @Color( 1 ) Stru stru;

    pragma( msg, __traits( getAttributes, Stru ) );
    pragma( msg, __traits( getAttributes, stru ) );
    pragma( msg, __traits( getAttributes, typeof( stru ) ) );

    writeln( stru.parent );
}
