import std.stdio;
import core.sys.windows.windows;
import core.sys.windows.shlobj  : IShellLink, SLGP_FLAGS;
import core.sys.windows.objidl  : IPersistFile;
import core.sys.windows.com     : CoCreateInstance, CLSCTX_INPROC_SERVER, IID;
import core.sys.windows.com     : CoInitializeEx, CoUninitialize, COINIT_MULTITHREADED;
import core.sys.windows.objbase;
import core.sys.windows.uuid;
import std.conv                 : to;
//import core.stdc.wchar_         : wcslen;
import uno.sys.utf;
import uno.sys.com              : ComPtr, CoEnforce;

pragma( lib, "Shell32.lib" );
pragma( lib, "user32.lib" ); // MessageBox




auto CoCreateInst( IFACE )( const IID clsid, DWORD dwClsContext )
{
    ComPtr!IFACE   shellLink;
    //auto           cls = IFACE.cls; // &CLSID_ShellLink
    //auto           iid = IFACE.iid; // &IID_IShellLink
    mixin(
        "auto iid = &IID_"   ~ IFACE.stringof ~ ";"
    );
    
    CoEnforce(
        CoCreateInstance( &clsid, null, dwClsContext, iid, cast(void**)&shellLink )
    );
    
    return shellLink;
}


/*

    //
    struct IShellLinkW_Wrapper
    {
        IShellLinkW shellLink;
        
        
        auto QueryInterface( IPersistFile iface )
        {
            IPersistFile persistFile;
            
            CoEnforce(
                shellLink.QueryInterface( iface, cast(void**)&persistFile )
            );
            
            return persistFile;
        }
        
        
        auto GetPath( SLGP_FLAGS flags )
        {
            // Get the path to the link target.
            WCHAR[MAX_PATH] szGotPath;
            WIN32_FIND_DATA wfd;

            CoEnforce(
                shellLink.GetPath( szGotPath.ptr, szGotPath.length, cast( WIN32_FIND_DATA* )&wfd, flags )
            }
            
            string path = szGotPath[ 0 .. wcslen( szGotPath.ptr ) ].to!string;
            
            return path;
        }
        
        
        auto GetDescription()
        {
            WCHAR[MAX_PATH] szDescription;

            CoEnforce(
                shellLink.GetDescription( szDescription.ptr, szDescription.length )
            );
            
            string desc = szDescription[ 0 .. wcslen( szDescription.ptr ) ].to!string;
            
            return desc;
        }
    }
    
    return ComInner;
}


void x()
{
    auto shellLink      = Com!IShellLinkW().CoCreateInstance( CLSCTX_INPROC_SERVER );
    auto isLoaded       = shellLink.QueryInterface( IPersistFile ).Load( fileName.toLPWSTR, STGM_READ );
    auto path           = shellLink.GetPath( SLGP_FLAGS.SLGP_SHORTPATH );
    auto description    = shellLink.GetDescription();
    auto icon           = shellLink.GetIconLocation();

    //
    IShellLink shellLink;
    HRESULT hres = CoCreateInstance( &CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER, &IID_IShellLinkW, cast(void**)&shellLink );

    IPersistFile persistFile;        
    hres = shellLink.QueryInterface( &IID_IPersistFile, cast(void**)&persistFile );

    hres = persistFile.Load( fileName.toLPWSTR, STGM_READ );

    HRESULT hres = shellLink.GetPath( szGotPath.ptr, szGotPath.length, cast( WIN32_FIND_DATA* )&wfd, SLGP_FLAGS.SLGP_SHORTPATH );
}
*/

void main()
{
    CoInitializeEx( NULL, COINIT_MULTITHREADED );
    
    //
    string fileName = "C:\\Users\\All Users\\Microsoft\\Windows\\Start Menu\\Programs\\Brave.lnk";

    ComPtr!IShellLink shellLink;
    CoCreateInstance( &CLSID_ShellLink, null, CLSCTX_INPROC_SERVER, &IID_IShellLinkW, cast( void** )&shellLink );
    
    ComPtr!IPersistFile persistFile;
    shellLink.QueryInterface( &IID_IPersistFile, cast( void** )&persistFile );
    
    persistFile.Load( fileName.toLPWSTR, STGM_READ );

    //
    WCHAR[ MAX_PATH ] szGotPath;
    WIN32_FIND_DATA   wfd;

    shellLink.GetPath( szGotPath.ptr, to!int( szGotPath.length ), cast( WIN32_FIND_DATA* )&wfd, SLGP_FLAGS.SLGP_SHORTPATH );
    string path = WcharBufToString( szGotPath );

    //
    WCHAR[ MAX_PATH ] szDescription;

    shellLink.GetDescription( szDescription.ptr, to!int( szDescription.length ) );
    string desc = WcharBufToString( szDescription );

    //
    WCHAR[ MAX_PATH ] szIcon;
    int               iIcon;

    shellLink.GetIconLocation( szIcon.ptr, to!int( szIcon.length ), &iIcon );
    string iconPath = WcharBufToString( szIcon );
    int iconIndex   = iIcon;
    
    //
    writeln("Edit source/app.d to start your project.");

    CoUninitialize();
}


