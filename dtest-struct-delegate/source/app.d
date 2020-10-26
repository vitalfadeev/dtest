import std.stdio;


struct Style
{
    string   clasName;
    string[] checkers;
    STYLER   styler;

    string alignSelf;

    alias void delegate( Style* style ) STYLER;


    Style* AppendTo( Style*[] styles )
    {
        Style* style = &this;
        
        styles ~= style;

        return style;
    }
}


Style* NewStyle( string CLASSNAME, alias CHECKERS, FUNC )
{
    auto style = new Style( CLASSNAME, CHECKERS );
    return style;
}


void main()
{
    Style*[] styles;

    Style!( "right", [], {
        alignSelf = "flex-end";
    });
}
