import std.stdio;


struct RECT
{
    int x;
    int y;
    int w;
    int h;
}

struct S
{
    union 
    {
        struct
        {
            int         x;
            int         y;
            int         w;
            int         h;
        };
        RECT rect;
    }
}


void main()
{
	S s;
    auto a = s.x;
    auto rect = s.rect;
}
