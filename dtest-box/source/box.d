enum BoxType
{
    BOX,
    CHAR,
}


struct Box
{
    BoxType  type             = BoxType.BOX;
    Box*     firstChild       = null;
    Box*     lastChild        = null;
    Box*     parentBox        = null;
    Box*     previousSibling  = null;
    Box*     nextSibling      = null;

    int      offsetLeft;
    int      offsetTop;


    Box* appendChild( Box* child ) nothrow
    {
        // Add Last
        if ( lastChild is null )
        {
            lastChild  = child;
            firstChild = child;
        }
        else // lastChild !is null
        {
            auto oldLast          = lastChild;
            oldLast.nextSibling   = child;
            lastChild             = child;
            child.previousSibling = oldLast;

            if ( firstChild == oldLast )
            {
                firstChild = child;
            }
        }

        // Set Parent
        if ( child.parentBox !is null )
        {
            child.parentBox.removeChild( child );
            child.parentBox = &this;
        }
        else
        {
            child.parentBox = &this;            
        }

        return child;
    }


    Box* removeChild( Box* child ) nothrow
    {
        if ( child.parentBox == &this )
        {
            auto prev             = child.previousSibling;
            auto next             = child.nextSibling;
            prev.nextSibling      = next;
            next.previousSibling  = prev;

            child.previousSibling = null;
            child.nextSibling     = null;
            child.parentBox       = null;

            if ( firstChild == child )
            {
                if ( child.nextSibling !is null )
                {
                    firstChild = child.nextSibling;
                }
                else // child.nextSibling is null
                {
                    firstChild = null;
                }
            }

            if ( lastChild == child )
            {
                if ( child.previousSibling !is null )
                {
                    lastChild = child.previousSibling;
                }
                else // child.previousSibling is null
                {
                    lastChild = null;
                }
            }
        }

        return child;
    }
}

/*
struct Style
{
    Value margin            = "";
    Value marginLeft        = 0;
    Value marginTop         = 0;
    Value marginRight       = 0;
    Value marginBottom      = 0;

    Value padding           = "";
    Value paddingLeft       = 0;
    Value paddingTop        = 0;
    Value paddingRight      = 0;
    Value paddingBottom     = 0;

    Value borderWidth       = "";
    Value borderLeftWidth   = 0;
    Value borderTopWidth    = 0;
    Value borderRightWidth  = 0;
    Value borderBottomWidth = 0;

    Value left              = 0;
    Value top               = 0;
    Value right             = 0;
    Value bottom            = 0;

    Value width             = "auto";
    Value height            = "auto";

    Value display           = "inline";
    Value position          = "static";

    Value value             = "";
}
*/

/*
struct Computed
{
    // Margin
    union
    {
        RECT margin;
        struct
        {        
            int marginLeft;
            int marginTop;
            int marginRight;
            int marginBottom;
        }
    }

    // Border
    union
    {
        RECT border;
        struct
        {        
            int borderLeft;
            int borderTop;
            int borderRight;
            int borderBottom;
        }
    }

    // Padding
    union
    {
        RECT padding;
        struct
        {        
            int paddingLeft;
            int paddingTop;
            int paddingRight;
            int paddingBottom;
        }
    }

    // Content
    union
    {
        RECT content;
        struct
        {        
            int contentLeft;
            int contentTop;
            int contentRight;
            int contentBottom;
        }
    }

    dchar value;           // unsigned 32 bit ( UTF-32 code unit )
}

*/