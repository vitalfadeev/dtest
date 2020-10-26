import std.stdio;


alias bool function() CHECKER;
alias void function( Uno This ) STYLER;


interface ICheckable
{
    bool IsMouseOver();
    bool IsFocused();
    bool IsSelected();
}


class Style
{
    string      className;
    CHECKER[]   checkers;
    STYLER      styler;


    this( string className, CHECKER[] checkers, STYLER styler )
    {
        this.className = className;
        this.checkers = checkers;
        this.styler = styler;
    }
}


void CustomStyle( Uno obj )
{
    Style[] styles;
    

    // Default
    styles ~= new Style( "", [ &ICheckable.IsFocused ], ( Uno This ) {
        //
    } );
}


class Uno : ICheckable
{
    bool HasMouseOver() { return false; }
    bool HasFocus() { return false; }
    bool HasSelected() { return false; }

    // ICheckable
    bool IsMouseOver()
    {
        return HasMouseOver();
    }


    bool IsFocused()
    {
        return HasFocus();
    }


    bool IsSelected()
    {
        return HasSelected();
    }
}


void main()
{
    auto a = new Uno();
    CustomStyle( a );

	writeln("OK");
}

