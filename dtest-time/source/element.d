import core.sys.windows.windows;
import std.algorithm : remove;
import value         : Value;
import tools         : Writeln;
import tools         : Writefln;
import tools         : GET_X_LPARAM;
import tools         : GET_Y_LPARAM;
import event         : Event;
import event         : EventType;
import eventtarget   : EventListener;
import promise       : Promise;
import node          : Node;
import node          : NodeType;
import std.string    : split;
import std.array     : join;

alias uint COLORREF;


struct COLOR
{
    COLORREF valueNative;
}


COLOR RGB( ubyte r, ubyte g, ubyte b )
{
    COLORREF valueNative = ( ( b << 16 ) | ( g << 8 ) | r ); // BGR

    return COLOR( valueNative );
}


struct Style
{
    Value left              = 0;
    Value top               = 0;
    Value right             = 0;
    Value bottom            = 0;

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

    Value width             = "auto";
    Value height            = "auto";

    Value display           = "inline";
    Value position          = "static";

    Value lineHeight        = "inherit";
    Value wrapLine          = 0;
    Value overflow          = "visible";
    Value overflowX         = "visible";
    Value overflowY         = "visible";
}


struct Computed
{
    union
    {
        struct
        {        
            int left   = 0;
            int top    = 0;
            int right  = 0;
            int bottom = 0;
        };
        RECT rect;
    }

    union
    {
        struct
        {        
            int marginLeft   = 0;
            int marginTop    = 0;
            int marginRight  = 0;
            int marginBottom = 0;
        };
        RECT margin;
    }

    union
    {
        struct
        {        
            int paddingLeft   = 0;
            int paddingTop    = 0;
            int paddingRight  = 0;
            int paddingBottom = 0;
        };
        RECT padding;
    }

    union
    {
        struct
        {        
            int borderLeftWidth   = 0;
            int borderTopWidth    = 0;
            int borderRightWidth  = 0;
            int borderBottomWidth = 0;
        };
        RECT borderWidth;
    }

    WidthMode       widthMode       = WidthMode.AUTO;
    int             width           = 0;
    HeightMode      heightMode      = HeightMode.AUTO;
    int             height          = 0;

    DisplayOutside  displayOutside  = DisplayOutside.INLINE;
    DisplayInside   displayInside   = DisplayInside.FLOW;
    int             displayListitem = 0;
    DisplayInternal displayInternal = DisplayInternal.TABLE_ROW_GROUP;
    DisplayBox      displayBox      = DisplayBox.CONTENTS;
    DisplayLegacy   displayLegacy   = DisplayLegacy.INLINE_BLOCK;
    bool            displayIsBlockLevel;

    Position        position        = Position.STATIC;

    BoxSizing       boxSizing       = BoxSizing.CONTENT_BOX;

    int             lineHeight      = 12;
    int             wrapLine        = 0;
    Overflow        overflowX       = Overflow.VISIBLE;
    Overflow        overflowY       = Overflow.VISIBLE;

    Content         content;
}


struct Content
{
    string before;
    string text;
    string after;
}


enum Position
{
    STATIC, 
    RELATIVE, 
    ABSOLUTE,
    STICKY,
    FIXED
}


enum WidthMode
{
    AUTO,
    LENGTH,
    PERCENTAGE,
    MIN_CONTENT, 
    MAX_CONTENT,
    FIT_CONTENT
}


enum HeightMode
{
    AUTO,
    LENGTH,
    PERCENTAGE,
    MIN_CONTENT, 
    MAX_CONTENT,
    FIT_CONTENT
}


enum BoxSizing 
{
    CONTENT_BOX,
    BORDER_BOX,    
}


enum ElementState
{
    a,
    b,
    c,
    d
}


enum DisplayOutside
{
    INLINE,
    BLOCK,
    RUN_IN
}


enum DisplayInside
{
    FLOW, 
    FLOW_ROOT, 
    TABLE, 
    FLEX, 
    GRID, 
    RUBY
}


enum DisplayBox
{
    CONTENTS, 
    NONE
}


enum DisplayInternal
{
    TABLE_ROW_GROUP, 
    TABLE_HEADER_GROUP, 
    TABLE_FOOTER_GROUP, 
    TABLE_ROW, 
    TABLE_CELL, 
    TABLE_COLUMN_GROUP, 
    TABLE_COLUMN, 
    TABLE_CAPTION, 
    RUBY_BASE, 
    RUBY_TEXT, 
    RUBY_BASE_CONTAINER, 
    RUBY_TEXT_CONTAINER
}


enum DisplayLegacy
{
    INLINE_BLOCK, 
    INLINE_LIST_ITEM, 
    INLINE_TABLE, 
    INLINE_FLEX, 
    INLINE_GRID
}


enum Overflow
{
    VISIBLE,
    HIDDEN,
    SCROLL,
    AUTO
}


struct HTMLCollection
{
    Element*[] items;

    //Node* firstChild;
    //Node* lastChild;


    pragma( inline )
    auto length()
    {
        return items.length;
    }


    Element* item( uint index )
    {
        return items[ index ];
    }
}


struct Element
{
    Node node = { nodeType: NodeType.ELEMENT };

    ElementState elementState;
    Style        style;         // attributes 
    Computed     computed;
    string[]     classList;

    Element* offsetParent; // computed only
    union
    {
        struct
        {        
            int      offsetLeft;   // computed only
            int      offsetTop;    // computed only
            int      offsetRight;  // computed only
            int      offsetBottom; // computed only
        };
        RECT offset;
    }
    int      offsetWidth;  // computed only
    int      offsetHeight; // computed only



    //
    pragma( inline )
    bool hidden()
    {
        return ( comuted.display == Display.NONE ) ? true : false;
    }

    //
    void         className( string newClassName )
    {
        classList = newClassName.split( " " );
    }

    string       className()
    {
        return classList.join( " " );
    }

    uint         childElementCount() 
    { 
        if ( firstElementChild is null )
        {
            return 0;
        }
        else
        {
            uint counter; 

            for ( auto c = firstElementChild; c !is null; c = c.nextElementSibling ) 
                counter++; 

            return counter; 
        }
    };

    HTMLCollection* children()
    {
        auto collection = new HTMLCollection();

        //

        return collection;
    }

    uint         clientHeight;
    uint         clientLeft;
    uint         clientTop;
    uint         clientWidth; // content.width + padding.width ( no borders, no margins )
    pragma( inline ) 
    Element*     firstElementChild() nothrow { return cast( Element* ) node.firstChild; }
    string       id;
    pragma( inline ) 
    Element*     lastElementChild()  nothrow { return cast( Element* ) node.lastChild; }
    pragma( inline ) 
    Element*     nextElementSibling() nothrow  { return cast( Element* ) node.nextSibling; }
    pragma( inline ) 
    Element*     previousElementSibling() nothrow { return cast( Element* ) node.previousSibling; }
    int          scrollHeight;
    int          scrollLeft;
    int          scrollTop;
    int          scrollWidth;
    string       tagName;


    Element* addChild( Element* c ) nothrow
    {
        return cast( Element* ) node.appendChild( cast( Node* ) c );
    }


    void addEventListener( EventType type, EventListener* listener )
    {
        //
    }


    Element* closest( string selector )
    {
        Element* scan = &this;

        do
        {
            if ( scan.matches( selector ) )
            {
                return scan;
            }

            scan = scan.parentElement;
        } while ( scan !is null );

        return null;
    }


    bool dispatchEvent( Event* event ) nothrow
    {
        bool cancelled = false;

        switch ( event.msg.message )
        {
            case WM_LBUTTONDOWN: {
                POINT pt;

                pt.x = GET_X_LPARAM( event.msg.lParam );
                pt.y = GET_Y_LPARAM( event.msg.lParam );

                if ( HitTest( pt ) )
                {
                    MouseClick();
                }
                break;                
            }
            default:
        }

        // To Childs
        if ( firstElementChild !is null )
        {        
            for( auto c = firstElementChild; c !is null; c = c.nextElementSibling )
            {
                c.dispatchEvent( event );
            }
        }

        return cancelled;
    }


    Element* find()
    {
        return null;
    }


    Element*[] findAll()
    {
        return [];
    }


    auto getAttribute( string attributeName )()
    {
        return __traits( getMember, style, attributeName );
    }


    void getBoundingClientRect( RECT* rect )
    {
        // возвращает размер элемента и его позицию относительно viewport 
        // ( часть страницы, показанная на экране, и которую мы видим ).
        // *rect = boundingClientRect;
    }


    HTMLCollection* getElementsByClassName( string names )
    {
        auto collection = new HTMLCollection();

        //

        return collection;
    }


    HTMLCollection* getElementsByTagName()( string tagName )
    {
        auto collection = new HTMLCollection();

        //

        return collection;
    }


    pragma( inline )
    bool hasAttribute( string attName )()
    {
        return __traits( getMember, style, attName ).modiied;
    }


    void insertAdjacentHTML( string position, string text )
    {
        //
    }


    bool matches( string selector ) 
    {
        //

        return false;
    }


    Element* parentElement() nothrow
    {
        return cast( Element* ) node.parentNode;
    }


    Node* querySelector( string[] selectors )
    {
        return null;
    }


    Node*[] querySelectorAll( string[] selectors )
    {
        return [];
    }


    Node* remove()
    {
        return node.parentNode.removeChild( cast( Node* ) &this );
    }


    void removeAttribute( string attrName )()
    {
        __traits( getMember,  style, attrName ).modiied = false;
    }


    Element* removeChild( Element* c ) nothrow
    {
        return cast( Element* ) node.removeChild( cast( Node* ) c );
    }


    void removeEventListener( EventType type, EventListener* listener )
    {
        //
    }


    Promise requestFullscreen()
    {
        auto promise = new Promise();

        return promise;
    }


    void scrollIntoView()
    {
        //
    }


    void setAttribute( T )( string name, T value )
    {
        __traits( getMember, style, name ) = value;
    }


    void foreachChild( void function( Element* node ) callback )
    {
        if ( firstElementChild !is null )
        {        
            for( auto c = firstElementChild; c !is null; c = c.nextElementSibling )
            {
                callback( c );
            }
        }
    }


    //
    bool HitTest( POINT pt ) nothrow
    {
        return cast( bool ) PtInRect( &computed.rect, pt );
    }


    void MouseClick() nothrow
    {
        Writefln( "MouseClick()" );
    }
}


