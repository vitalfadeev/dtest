import std.stdio;
import std.string;


class Base 
{
	Base[] childs;
	string id;

	
	T S( T )( string id )
	{
		// searching... in wide
		foreach( child; childs )
		{
			if ( child.id == id )
				if ( typeid( child ) == typeid( T ) )
					return cast( T )child;
		}

		foreach( child; childs )
		{
			auto r = child.S!T( id );

			if ( r )
				return r;
		}
		
		throw new Exception( "object with id: '" ~ id ~ "' and class: '" ~ T.toString ~ "': not found" );
		//return null;
	}
}


class A : Base {}
class B : Base {}


T safeCast( T, CLS )( CLS o )
{
	if ( typeid( o ) == typeid( T ) )
		return cast(T)o;
	else
		throw new Exception( "casting error" );
}


void main()
{	
    Base a = new A();

    A x1 = cast( A )a;      // ok
    B x2 = cast( B )a;      // ok, but unsafe
    //B x3 = safeCast!B( a ); // throw exception
    A x4 = safeCast!A( a ); // ok
    
    a.S!A( "x" ).x;
}

