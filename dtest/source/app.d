import std.stdio;
import std.string;


struct Event
{
    void attach( void delegate () )
    {
        //
    }

    void opAssign( void delegate () )
    {
        //
    }
}

struct Events
{
    Event Click;
}

class Base
{
    Events on;
    
    this ()
    {
        //
    }
}


class A : Base
{
    override
    string toString()
    {
        return "A";
    }
}


struct PARAMS
{
    void delegate () Click;
}


class Main : Base
{
    this()
    {
        with ( new A )
        {
            on.Click = &OnAClick;
        }
    }
    
    void OnAClick()
    {
        //
    }
}

    
void main()
{
    new Main();
}


