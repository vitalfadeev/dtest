import std.stdio;


enum ValueType
{
    UNDEFINED,
    UINT,
}


struct Value
{
    ValueType type;

    union
    {
        uint valueUint;
    }


    void opAssign( uint v )
    {
        type = ValueType.UINT;
        valueUint = v;
    }


    void opCast( uint v )
    {
        type = ValueType.UINT;
        valueUint = v;
    }
}


struct Properties
{
    uint color;
}


alias void function( void* event ) CALLBACK;


mixin template Element()
{    
    void* parent;
    Properties props;

    CALLBACK onClick;
}


struct Element2( string CLASSES )
{
    //
}


mixin template EventHandler()
{
    // clickCallback
    //   each Element
    //       if has function "onClick"
    //         call onClick()
}


struct Clock
{
    mixin Element;
}


struct Indicators
{
    mixin Element;

    Sound sound;
}


struct Sound
{
    mixin Element;
}


void EachElement( T, CALLBACK )()
{
    // each attr
    //   if IsElement
    //     callback
}


bool IsElement( T )()
{
    // if 
    //   has  Element
    //   has  T.props
    //   type T.props is Properties
}


void Walk( T )( T obj )
{
    //
}


void* Parent( T )( T obj )
{
    // __traits( parent, T );
}



void App( ROOT_ELEMENT )()
{
    ROOT_ELEMENT root;

    // Update Parents
}


struct Screen( ARGS... )
{
    //
}


struct Window( ROOT_ELEMENT )
{
    ROOT_ELEMENT root;


    void OnClickCallback( void* event )
    {
        static if ( HasOnClick!ROOT_ELEMENT() )
        {
            root.OnClick( event);
        }
    }
}


bool HasOnClick( T )()
{
    return true;
}


struct Panel
{
    mixin Element;

    //Element2!() applications2;


    struct Applications
    {
        mixin Element;

        pragma( msg,  __traits( parent, Applications ).stringof );
        pragma( msg,  __traits( parent, Panel ).stringof );


        void onClick( void* event )
        {
            //
        }
    }


    Applications applications;
    Clock        clock;
    Indicators   indicators;


    void OnClick( void* event )
    {
        writefln( "Panel_OnClick()" );
    }
}


void main()
{
    App!( Window!Panel );

    //writefln( "color = %d", app.root.props.color );
}

