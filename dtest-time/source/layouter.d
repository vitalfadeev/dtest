import core.sys.windows.windows;
import tools   : max;
import element : Element;


struct InlineLayouter
{
    HDC      hdc;
    Element* element;
    RECT     limits;
    POINT    offset;
    RECT     margin;
    uint     lineHeight;


    void Inline_Flow_Layout() nothrow
    {
        Inline_Flow_Layout();
    }


    pragma( inline )
    void Inline_Flow_Layout() nothrow
    {
        ComputeWidth();

        if ( offset.x + element.offsetWidth < limits.right )
        {  
            // No-Wrap      
            element.offsetLeft = offset.x + max( margin.right, element.computed.marginLeft );
            element.offsetTop  = offset.y + max( margin.bottom, element.computed.marginTop );

            offset.x += element.offsetWidth;
        }
        else 
        {    
            // Wrap    
            offset.x = 0;
            offset.y = offset.y + lineHeight;
            element.offsetLeft = offset.x + max( mergin.right, element.computed.marginLeft);        
            element.offsetTop  = offset.y + max( margin.bottom, element.computed.marginTop );

            offset.x += element.offsetWidth;
        }
    }


    pragma( inline )
    void ComputeWidth() nothrow
    {
        // Width
        if ( element.hidden )
        {
            element.offsetWidth = 0;
        }
        else
        {
            // border.width + padding.width + contentWidth
            uint contentWidth = ComputeContentWidth();

            element.offsetWidth = 
                element.computed.borderLeft + 
                element.computed.paddingLeft + 
                contentWidth + 
                element.computed.paddingRight +
                element.computed.borderRight; 
        }        
    }


    pragma( inline )
    uint ComputeContentWidth() nothrow
    {
        return ComputeCharWidth();
    }


    pragma( inline )
    uint ComputeCharWidth() nothrow
    {
        return 10;
    }
}

