import std.stdio;
import std.typecons;

alias Tuple!( bool, "hasParent", int, "parent" ) ParentResult;


struct Node
{
    bool hasParent;

    ParentResult parent()
    {
        ParentResult res;

        if ( hasParent )
        {
            res.hasParent = hasParent;
            res.parent = 1;
        }
        else
        {
            res.hasParent = hasParent;
            res.parent = 0;
        }

        return res;
    }
}


void testNode()
{
    Node n;
    auto p = n.parent();

    if ( p.hasParent )
    {
        writeln( p.parent );
    }
    else
    {
        writeln( null );
    }
}


void main()
{
	testNode();
}
