static import winapi = core.sys.windows.windows;

struct HDC
{
    winapi.HDC hdc;


    alias winapi.SelectObject     SelectObject;
    alias winapi.Rectangle        Rectangle;
    alias winapi.MoveToEx         MoveToEx;
    alias winapi.LineTo           LineTo;
    alias winapi.SetTextAlign     SetTextAlign;
    alias winapi.TextOutW         TextOutW;
    alias winapi.GetViewportExtEx GetViewportExtEx;
}

