import std.stdio;


class Path
{
    string s;
}


class Button( DataClass = Path )
{
    DataClass data;
}


void main()
{
    auto button = new Button!();
}

