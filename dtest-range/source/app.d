import std.stdio;
import std.format : format;
import std.conv : to;


class Uno
{
    Uno left;
    Uno right;
	Uno firstChild;
	Uno lastChild;
	Uno parent;

    alias firstChild childs;
    

    int opApply( int delegate( ref Uno ) dg )
    {
        int result = 0;

        for ( Uno scan = this; scan !is null; scan = scan.right ) 
        {
            result = dg( scan );

            if (result) 
            {
                break;
            }
        }

        return result;
    }
    

    //
    void AddChild( Uno child )
    {
        child.Mount( this );
    }

    //
	void Mount( Uno parent )
	{
        //
        this.parent = parent;
        
        auto plc = parent.lastChild;

        if ( plc is null )
        {
            parent.firstChild = this;
            parent.lastChild  = this;
        }
        else
        {            
            plc.right = this;
            this.left = plc;
            parent.lastChild = this;
        }
        
        //
        //this.window = parent.window;
	}
    
    
    size_t childsCount()
    {
        size_t l;
        
        for ( Uno scan = firstChild; scan !is null; scan = scan.right ) 
            l++;
        
        return l;
    }


    override
    string toString()
    {
        return format!"%s[ l:%X, r:%X, p:%X, c:[ %X .. %X ] ]"
        (
            typeof( this ).stringof,
            ( cast( size_t ) cast( void* ) left ),
            ( cast( size_t ) cast( void* ) right ),
            ( cast( size_t ) cast( void* ) parent ),
            ( cast( size_t ) cast( void* ) firstChild ),
            ( cast( size_t ) cast( void* ) lastChild )
        );
    }
}


void main()
{
    auto lst = new Uno();
    auto child1 = new Uno();
    auto child2 = new Uno();
    
    lst.AddChild( child1 );
    lst.AddChild( child2 );
    
	foreach( c; lst.childs )
    {
        writeln( c );
    }
}


