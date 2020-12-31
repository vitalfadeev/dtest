module direntry;

import std.datetime.systime : Clock, SysTime, unixTimeToStdTime;
import std.internal.cstring;
import std.meta;
import std.range.primitives;
import std.traits;
import std.typecons;
import std.algorithm : canFind;


version ( Windows )
{
    import core.sys.windows.winbase, core.sys.windows.winnt, std.windows.syserror;
}

version ( Windows )
{
    private alias FSChar = WCHAR;       // WCHAR can be aliased to wchar or wchar_t
}

version ( Windows ) 
{
    private 
    ulong makeUlong( DWORD dwLow, DWORD dwHigh ) @safe pure nothrow @nogc
    {
        ULARGE_INTEGER li;
        li.LowPart  = dwLow;
        li.HighPart = dwHigh;

        return li.QuadPart;
    }
}

version ( Windows )
{
    import std.datetime.systime : FILETIMEToSysTime;
}


class FileException : Exception
{
    this( ARGS )( ARGS args... )
    {
        super( args );
    }
}


struct DirEntry
{
@safe:
public:
    @property string name() const pure nothrow
    {
        return _name;
    }

    alias name this;


    this( string pathname ) @trusted
    {
        if ( isRootPath( pathname ) )
        {
            _name = pathname;

            with ( getFileAttributesWin( pathname ) )
            {
                _size             = makeUlong( nFileSizeLow, nFileSizeHigh );
                _timeCreated      = ftCreationTime;
                _timeLastAccessed = ftLastAccessTime;
                _timeLastModified = ftLastWriteTime;
                _attributes       = dwFileAttributes;
            }
        }
        else
        {
            WIN32_FIND_DATAW fd;

            HANDLE hFind = FindFirstFileW( pathname.tempCString!FSChar(), &fd );

            if ( hFind == INVALID_HANDLE_VALUE )
            {
                //
            }
            else
            {
                fd.cFileName[ $ - 1 ] = 0;

                _name             = pathname;
                _size             = makeUlong( fd.nFileSizeLow, fd.nFileSizeHigh );
                _timeCreated      = fd.ftCreationTime;
                _timeLastAccessed = fd.ftLastAccessTime;
                _timeLastModified = fd.ftLastWriteTime;
                _attributes       = fd.dwFileAttributes;

                FindClose( hFind );
            }
        }
    }


    private this( string pathname, WIN32_FIND_DATAW *fd ) @trusted
    {
        _name             = pathname;
        _size             = makeUlong( fd.nFileSizeLow, fd.nFileSizeHigh );
        _timeCreated      = fd.ftCreationTime;
        _timeLastAccessed = fd.ftLastAccessTime;
        _timeLastModified = fd.ftLastWriteTime;
        _attributes       = fd.dwFileAttributes;
    }


    @property bool isDir() const pure nothrow
    {
        return ( attributes & FILE_ATTRIBUTE_DIRECTORY ) != 0;
    }

    @property bool isFile() const pure nothrow
    {
        //Are there no options in Windows other than directory and file?
        //If there are, then this probably isn't the best way to determine
        //whether this DirEntry is a file or not.
        return !isDir;
    }

    @property bool isSymlink() const pure nothrow
    {
        return ( attributes & FILE_ATTRIBUTE_REPARSE_POINT ) != 0;
    }

    @property ulong size() const pure nothrow
    {
        return _size;
    }

    @property SysTime timeCreated() const nothrow
    {
        return FILETIMEToSysTimeTrusted( &_timeCreated );
    }

    @property SysTime timeLastAccessed() const nothrow
    {
        return FILETIMEToSysTimeTrusted( &_timeLastAccessed );
    }

    @property SysTime timeLastModified() const nothrow
    {
        return FILETIMEToSysTimeTrusted( &_timeLastModified );
    }

    @property uint attributes() const pure nothrow
    {
        return _attributes;
    }

    @property uint linkAttributes() const pure nothrow
    {
        return _attributes;
    }


private:
    bool isRootPath( string path )
    {
        // File path formats on Windows systems:
        //   https://docs.microsoft.com/en-us/dotnet/standard/io/file-path-formats
        // "\"
        // "C:\"
        // "\\.\C:\"
        // "\\?\C:\"
        // "\\.\Volume{b75e2c83-0000-0000-0000-602f00000000}\"
        // "\\system07\C$\"

        if ( path == r"\" )
        {
            return true;
        }

        if ( path.length == 3 && isDosDriveLetter( path[ 0 ] ) && path[ 1 .. $ ] == r":\" )
        {
            return true;
        }

        if ( path == r"\\.\" )
        {
            return true;
        }

        if ( path == r"\\?\" )
        {
            return true;
        }

        if ( path.length > 2 && path[ 0 .. 2 ] == r"\\" && !hasSlashes( path[ 2 .. $ ] ) )
        {
            return true;
        }

        return false;
    } 


    bool isDosDriveLetter( wchar c )
    {
        if ( c >= 'A' && c <= 'Z' )
        {
            return true;
        }

        if ( c >= 'a' && c <= 'z' )
        {
            return true;
        }

        return false;
    }


    bool hasSlashes( string s )
    {
        return s.canFind( '\\' );
    }


private:
    string   _name; /// The file or directory represented by this DirEntry.

    FILETIME _timeCreated;      /// The time when the file was created.
    FILETIME _timeLastAccessed; /// The time when the file was last accessed.
    FILETIME _timeLastModified; /// The time when the file was last modified.

    ulong    _size;       /// The size of the file in bytes.
    uint     _attributes; /// The file attributes from WIN32_FIND_DATAW.
}


version ( Windows) private WIN32_FILE_ATTRIBUTE_DATA getFileAttributesWin( R )( R name )
  if ( isInputRange!R && !isInfinite!R && isSomeChar!( ElementEncodingType!R ) )
{
    auto namez = name.tempCString!FSChar();

    WIN32_FILE_ATTRIBUTE_DATA fad = void;

    static if ( isNarrowString!R && is( immutable ElementEncodingType!R == immutable char ) )
    {
        static void getFA( scope const( char )[] name, scope const( FSChar )* namez, out WIN32_FILE_ATTRIBUTE_DATA fad ) @trusted
        {
            import std.exception : enforce;

            enforce( 
                GetFileAttributesExW( 
                    namez, 
                    GET_FILEEX_INFO_LEVELS.GetFileExInfoStandard, 
                    &fad 
                ), 
                new FileException( name.idup ) 
            );
        }

        getFA( name, namez, fad );
    }
    else
    {
        static void getFA( scope const( FSChar )* namez, out WIN32_FILE_ATTRIBUTE_DATA fad ) @trusted
        {
            import core.stdc.wchar_ : wcslen;
            import std.conv : to;
            import std.exception : enforce;

            enforce(
                GetFileAttributesExW( 
                    namez, 
                    GET_FILEEX_INFO_LEVELS.GetFileExInfoStandard, 
                    &fad 
                ), 
                new FileException( namez[ 0 .. wcslen( namez ) ].to!string ) 
            );
        }

        getFA( namez, fad );
    }

    return fad;
}



private struct DirIteratorImpl
{
  @safe:
    string   _path;
    DirEntry _cur;

    version ( Windows )
    {
        WIN32_FIND_DATAW _findinfo;
        HANDLE           _handle = NULL;

        
        bool next()
        {
            if ( _handle == NULL )
            {
                return false;
            }
            else
            {
                return toNext( true, &_findinfo );
            }
        }


        bool toNext( bool fetch, WIN32_FIND_DATAW* findinfo ) @trusted
        {
            import core.stdc.wchar_ : wcscmp;

            if ( fetch )
            {
                if ( FindNextFileW( _handle, findinfo ) == FALSE )
                {
                    // GetLastError() == ERROR_NO_MORE_FILES
                    FindClose( _handle );
                    _handle = NULL;
                    return false;
                }
            }

            while ( wcscmp( &findinfo.cFileName[ 0 ], "." ) == 0 ||
                    wcscmp( &findinfo.cFileName[ 0 ], ".." ) == 0 )
            {
                if ( FindNextFileW( _handle, findinfo ) == FALSE )
                {
                    // GetLastError() == ERROR_NO_MORE_FILES
                    FindClose( _handle );
                    _handle = NULL;
                    return false;
                }
            }

            //
            import core.stdc.wchar_ : wcslen;
            import std.path         : buildPath;
            import std.conv         : to;

            size_t clength = wcslen( &findinfo.cFileName[ 0 ] );
            string name    = buildPath( _path, findinfo.cFileName[ 0 .. clength ].to!string );

            _cur = DirEntry( name, findinfo );
            
            return true;
        }
    }


    this( string pathnameStr )
    {
        _path = pathnameStr;

        //
        import std.path : chainPath;

        auto searchPattern = chainPath( pathnameStr, "*.*" );

        static auto trustedFindFirstFileW( typeof( searchPattern ) pattern, WIN32_FIND_DATAW* findinfo ) @trusted
        {
            return FindFirstFileW( pattern.tempCString!FSChar(), findinfo );
        }

        _handle = trustedFindFirstFileW( searchPattern, &_findinfo );

        if ( _handle == INVALID_HANDLE_VALUE )
        {
            _handle = NULL;
        }
        else
        {
            toNext( false, &_findinfo );
        }
    }


    @property bool empty()
    {
        return _handle == NULL;
    }

    
    @property DirEntry front()
    {
        return _cur;
    }


    void popFront()
    {
        next();
    }


    ~this() @trusted
    {
        if ( _handle != NULL )
        {
            FindClose( _handle );
        }
    }
}


struct DirIterator
{
@safe:
    RefCounted!( DirIteratorImpl, RefCountedAutoInitialize.no ) impl;
    this( string pathname ) @trusted
    {
        impl = typeof( impl )( pathname );
    }

public:
    @property bool     empty()    { return impl.empty; }
    @property DirEntry front()    { return impl.front; }
              void     popFront() { impl.popFront(); }
}



SysTime FILETIMEToSysTimeTrusted( const( FILETIME )* ft ) nothrow @trusted 
{
    import std.datetime.systime : FILETIMEToSysTime;

    try { return cast( SysTime ) FILETIMEToSysTime( ft ); }
    catch ( Exception e ) { return SysTime(); }
}
