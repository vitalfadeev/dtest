import std.stdio;


class A
{
    //
}


T CR( T )()
{
    T child = new T;

    return child;
}


void main()
{
    with ( CR!A )
    {
        //
    }	
}
