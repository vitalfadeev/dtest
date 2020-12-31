import core.sys.windows.windows;
static import winapi = core.sys.windows.windows;


enum EventType : UINT
{
    LBUTTONDOWN = winapi.WM_LBUTTONDOWN,
    MOUSEMOVE   = winapi.WM_MOUSEMOVE,
}


struct Event
{
    MSG msg;


    EventType eventType()
    {
        return cast( EventType ) msg.message;
    }
}

