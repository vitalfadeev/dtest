import std.stdio;


struct S
{
    int a = 1;
    int b = 2;
    int c = 3;

    void print()
    {
        
        writefln( "S.this.a: %d",  this.init.a );
    }
}


void main()
{
    S s;

	writefln( "s.a: %d",  s.a );
    writefln( "s.init.a: %d",  s.init.a );
    s.print();
}
