import std.stdio;
import std.format : format;


enum ALIGN
{
    TOP,
    LEFT, 
    RIGHT, 
    CENTER, 
    JUSTIFY, 
    INITIAL, 
    INHERIT,  // --> cumputed.align
}

enum ValueType
{
    UNDEFUNED,
    INT,
    UINT,
    STRING,
    ALIGN,
}


struct Value
{
    ValueType type = ValueType.UNDEFUNED;
    union
    {
        int    valueInt;
        uint   valueUint;
        string valueString;
        ALIGN  valueAlign;
    }


    void opAssign( string s )
    {
        type = ValueType.STRING;
        valueString = s;
    }
}


struct Properties
{
    Value alignContent;
    Value alignItems;
    Value alignSelf;
}


struct Computed
{
    ALIGN alignSelf;
}


struct Node
{
    Node* parent;
}


struct Element
{
    Node node;
    alias node this;

    //
    Properties props; // Element properties
    Properties style; // Style properties

    //
    Computed computed;  // <-- after Apply Style and Update. Initial Properties + Style Properties + Element Properties
}


template Compute_Property( string PNAME )
{
    const char[] Compute_Property = 
        format!
        (
            "if ( element.props.%s.type != ValueType.UNDEFUNED ) " ~  // Element Properties More Important
            "{                                                   " ~
            "    Compute_alignSelf( element.props.%s );          " ~
            "}                                                   " ~
            "else                                                " ~
            "if ( element.style.%s.type != ValueType.UNDEFUNED ) " ~  // Style Properties Less Important
            "{                                                   " ~
            "    Compute_%s( element.style.%s );                 " ~
            "}                                                   "
        )( PNAME, PNAME, PNAME, PNAME, PNAME );
}


struct ComputeProperties
{
    Element*    element;
    Properties* properties;
    Computed*   computed;


    void Compute()
    {
        *computed = Computed.init;

        mixin Compute_Property!"alignSelf";
    }


    void Compute_alignSelf( Value v )
    {
        //  auto | baseline | center | flex-start | flex-end | stretch | initial | inherit

        if ( v.type == ValueType.STRING )
        {
            if ( v.valueString == "center" )
            {
                computed.alignSelf = ALIGN.CENTER;
            }
            else
            if ( v.valueString == "right" )
            {
                computed.alignSelf = ALIGN.RIGHT;
            }
            else
            if ( v.valueString == "initial" )
            {
                computed.alignSelf = Computed.init.alignSelf;
            }
            else
            if ( v.valueString == "inherit" )
            {
                computed.alignSelf = ( cast( Element* ) element.parent ).computed.alignSelf;
            }        
        }
    }
}


void main()
{
	Element e;

    e.style.alignSelf = "inherit";

    writeln( "OK" );
}
