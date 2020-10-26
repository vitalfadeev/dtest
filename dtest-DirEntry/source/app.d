import std.stdio;
import core.sys.windows.windows;


void main()
{
    import std.file : DirEntry;

    writeln( DirEntry( "c:\\hiberfil.sys" ).isDir() ); 

    //writeln( INVALID_FILE_ATTRIBUTES );
    ////writeln( GetFileAttributesW( "c:\\hiberfil.sys" ) );

    //WIN32_FILE_ATTRIBUTE_DATA fa;
    //writeln( GetFileAttributesExW( "c:\\hiberfil.sys", GET_FILEEX_INFO_LEVELS.GetFileExInfoStandard, &fa ) );

    //WIN32_FIND_DATAW fd;
    //auto hFind = FindFirstFileW ( "c:\\hiberfil.sys", &fd );
    //if ( hFind != INVALID_HANDLE_VALUE )
    //{
    //    writeln( "[ OK ]" );
    //    FindClose( hFind );
    //}
}
