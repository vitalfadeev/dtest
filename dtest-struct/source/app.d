import std.stdio;


class Uno
{
    struct Border
    {
        int         padding;                           // px
    }

    struct Borders
    {
        Border left;
        Border top;
        Border right;
        Border bottom;

        @property void padding( int b )
        {
            left.padding   = b; 
            top.padding    = b; 
            right.padding  = b; 
            bottom.padding = b; 
        }
    }
    
    Borders border;
} 

void main()
{
	auto u = new Uno();
    u.border.padding = 10;
}
