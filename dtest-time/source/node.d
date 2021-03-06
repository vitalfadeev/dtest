import eventtarget : EventTarget;


enum BrowserNodeType
{
    ELEMENT           = 1,
    TEXT              = 3,
    COMMENT           = 8,
    DOCUMENT          = 9,
    DOCUMENT_TYPE     = 10,
    DOCUMENT_FRAGMENT = 11
}


struct Node
{
    EventTarget eventTarget;

    NodeType    nodeType         = NodeType.ELEMENT;
    dchar       nodeValue;       // unsigned 32 bit ( UTF-32 code unit )
    Node*       firstChild       = null;
    Node*       lastChild        = null;
    Node*       parentNode       = null;
    Node*       previousSibling  = null;
    Node*       nextSibling      = null;


    Node* appendChild( Node* child ) nothrow
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
        if ( child.parentNode !is null )
        {
            child.parentNode.removeChild( child );
            child.parentNode = &this;
        }
        else
        {
            child.parentNode = &this;            
        }

        return child;
    }


    Node* cloneNode()
    {
        auto cloned = new Node();

        if ( firstChild !is null )
        {        
            for( auto c = firstChild; c !is null; c = c.nextSibling )
            {
                cloned.appendChild( c.cloneNode() );
            }
        }

        return cloned;
    }


    bool contains( Node* other )
    {
        bool childContains;

        if ( firstChild !is null )
        {        
            for( auto c = firstChild; c !is null; c = c.nextSibling )
            {
                if ( c == other )
                {
                    return true;
                }

                // recursie
                childContains = c.contains( other );

                if ( childContains )
                {
                    return true;
                }
            }
        }

        return false;
    }


    pragma( inline )
    bool hasChildNodes()
    {
        if ( firstChild is null )
            return false;
        else
            return true;
    }


    Node* insertBefore( Node* newElement, Node* referenceElement )
    {
        // Insert Before
        newElement.nextSibling           = referenceElement;
        newElement.previousSibling       = referenceElement.previousSibling;
        referenceElement.previousSibling = newElement;

        // Set Parent
        if ( newElement.parentNode !is null )
        {
            newElement.parentNode.removeChild( newElement );
            newElement.parentNode = &this;
        }
        else
        {
            newElement.parentNode = &this;            
        }

        // First
        if ( referenceElement == firstChild )
        {
            firstChild = newElement;
        }

        return newElement;
    }


    bool isEqualNode( Node* b )
    {
        if ( nodeType == b.nodeType )
        {
            if ( true )
            {
                return true;
            }
        }

        return false;
    }


    void normalize()
    {
        //
    }


    Node* removeChild( Node* child ) nothrow
    {
        if ( child.parentNode == &this )
        {
            auto prev             = child.previousSibling;
            auto next             = child.nextSibling;
            prev.nextSibling      = next;
            next.previousSibling  = prev;

            child.previousSibling = null;
            child.nextSibling     = null;
            child.parentNode      = null;

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


    Node* replaceChild( Node* newChild, Node* oldChild )
    {
        newChild.previousSibling = oldChild.previousSibling;
        newChild.nextSibling     = oldChild.nextSibling;
        newChild.parentNode      = oldChild.parentNode;

        oldChild.previousSibling = null;
        oldChild.nextSibling     = null;
        oldChild.parentNode      = null;

        if ( firstChild == oldChild )
        {
            firstChild = newChild;
        }

        if ( lastChild == oldChild )
        {
            lastChild = newChild;
        }

        return oldChild;
    }


    string textContent()
    {
        return "";
    }


    void foreachChild( void function( Node* node ) callback )
    {
        if ( firstChild !is null )
        {        
            for( auto c = firstChild; c !is null; c = c.nextSibling )
            {
                callback( c );
            }
        }
    }
}


