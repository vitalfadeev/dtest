import core.sys.windows.windows;
import std.stdio;
import doc        : Doc;
import box        : Box;
import uno_window : CreateWindowUno;


void Do()
{
    auto unoWindow = CreateWindowUno();

    MainLoop();    
}


void MainLoop()
{
    MSG msg;
    RECT vrect;

    while ( GetMessage( &msg, NULL, 0, 0 ) )
    {
        TranslateMessage( &msg );
        DispatchMessage( &msg );
    }
}


void main()
{
    Do();
}

