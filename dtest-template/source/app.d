import std.stdio;


class Window
{
    //
}


void PaintTimerTick( alias window )()
{
    writeln( window );
}


void main()
{
	auto w = new Window();

    PaintTimerTick!w;
}
