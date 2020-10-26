import std.stdio;


//static import core.sys.windows.windows;
//alias core.sys.windows.windows winapi;

static import winapi = core.sys.windows.windows;


void main()
{
    winapi.RECT rect;

	writeln("Edit source/app.d to start your project.");

    // pragma( msg, __FUNCTION__, "(): ", __LINE__, ": ", "I msg" );
    static assert( false, "Message" );
}

