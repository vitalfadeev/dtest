import std.stdio;
import ui.layouts;
import ui.ilayout;


class Widget
{
    struct Layout
    {
        shared ILayout[] _layouts;

        void opAssign( void function() r )
        {
        }

        void opAssign( shared ILayout r )
        {
            _layouts.length = 1;
            _layouts[ 0 ] = r;
        }


        alias _layouts this;
    }
    
    
    Layout layout;
}


void main()
{
	auto w = new Widget();
    
    w.layout = VBox;
    
    //
    foreach( l; w.layout )
    {
        writeln( l );
    }
}

