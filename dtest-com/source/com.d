module uno.sys.com;

import core.sys.windows.windows;
import core.sys.windows.wtypes : BSTR;
import core.sys.windows.olectl : CONNECT_E_ADVISELIMIT, CONNECT_E_CANNOTCONNECT;
import core.atomic      : atomicOp;
import core.memory      : GC;
import core.stdc.string : memcpy;
import std.traits       : InterfacesTuple;
import std.utf          : toUTF8, toUTF16, toUTF16z;
import std.conv         : to;
import std.meta         : anySatisfy;
import std.algorithm.searching : any;
import std.string;
import std.exception;
import core.stdc.string;
import core.stdc.wchar_ : wcslen;
import uno.sys.utf      : toLPWSTR;

pragma (lib, "ole32.lib" );
pragma (lib, "OleAut32.lib" );


GUID MakeGuid( string str )()
{
    static assert(str.length==36, "Guid string must be 36 chars long");
    enum GUIDstring = "GUID(0x" ~ str[0..8] ~ ", 0x" ~ str[9..13] ~ ", 0x" ~ str[14..18] ~
        ", [0x" ~ str[19..21] ~ ", 0x" ~ str[21..23] ~ ", 0x" ~ str[24..26] ~ ", 0x" ~ str[26..28]
        ~ ", 0x" ~ str[28..30] ~ ", 0x" ~ str[30..32] ~ ", 0x" ~ str[32..34] ~ ", 0x" ~ str[34..36] ~ "])";
    return mixin(GUIDstring);
}


static immutable struct ComGuid 
{
	GUID guid;
}


bool hasGuidAttribute( T )() 
{
    bool result = false;
    
	foreach( attr; __traits( getAttributes, T ) )
    {
		static if ( is( typeof( attr ) == ComGuid ) )
        {
			result = true;
            break;
        }
    }
    
    return result;
}


template getGuidAttribute( T ) 
{
	static ComGuid helper() 
    {
		foreach( attr; __traits( getAttributes, T ) )
			static if ( is( typeof( attr ) == ComGuid ) )
				return attr;
		assert( 0 );
	}
	__gshared static immutable getGuidAttribute = helper();
}


mixin template InterfaceMethods( IFACE, alias OBJ )
{
    static foreach( methodName; __traits( allMembers, IFACE ) )
    {
        mixin (
                "void " ~ methodName ~ "( ARGS... )( ARGS args )    " ~
                "{                                                  " ~
                "    CoEnforce(                                     " ~
                "        OBJ." ~ methodName ~ "( args )             " ~
                "    );                                             " ~
                "}                                                  "
              );
    }
}


struct ComPtr( IFACE ) 
{
	IFACE ptr;
    
    alias ptr this;


	this( IFACE ptr ) 
    {
        this.ptr = ptr;
	}
	
    this( this ) 
    {
        if ( ptr )
            ptr.AddRef();
	}
	
    ~this() 
    {
        if ( ptr )
            ptr.Release();
	}
	
  	IFACE  opCast( T : IFACE ) () { return ptr; }
	IFACE* opCast( T : IFACE* )() { return &ptr; }
	bool   opCast( T : bool )  () { return ptr !is null; }
    

    mixin InterfaceMethods!( IFACE, ptr );


    /*
    void CoCreateInstance( GUID classId )
    {
        auto iid = getGuidAttribute!( IFACE ).guid;

        CoEnforce( 
            CoCreateInstance( &classId, null, CLSCTX_ALL, &iid, cast(void**) &ptr )
        );
    }
    */
}


template ComObject()
{
    import core.atomic : atomicOp;


    extern ( Windows )
    HRESULT QueryInterface( IID* riid, void** ppv )
    {
		import std.traits;
		foreach( iface; InterfacesTuple!( typeof( this ) ) ) 
        {
			static if ( hasGuidAttribute!iface() ) 
            {
				auto guid = getGuidAttribute!iface;
                
				if ( *riid == guid.guid ) 
                {
					*ppv = cast( void* ) cast( iface ) this;
                    AddRef();
					return S_OK;
				}
			} 
            else static if ( is( iface == IUnknown ) ) 
            {
				if ( IID_IUnknown == *riid ) 
                {
					*ppv = cast( void* ) cast( IUnknown ) this;
                    AddRef();
					return S_OK;
				}
			} 
        }

        *ppv = NULL;
        return E_NOINTERFACE;
    }


    extern ( Windows )
    ULONG AddRef()
    {
        return atomicOp!"+="( _refCount, 1 );
    }


    extern ( Windows )
    ULONG Release()
    {
        LONG lRef = atomicOp!"-="( _refCount, 1 );
        
        if ( lRef == 0 )
        {
            // free object

            // If we delete this object, then the postinvariant called upon
            // return from Release() will fail.
            // Just let the GC reap it.
            //delete this;

            return 0;
        }
        return cast( ULONG )lRef;
    }


    shared( LONG ) _refCount;
}


class COMException : Exception
{
	immutable HRESULT error;

	this( HRESULT hr, string fn = __FILE__, size_t ln = __LINE__ )
	{
		import std.string : format;
		error = hr;
		super( format( "error occured during COM call (0x%X)", hr ), fn, ln );
	}
}


void CoEnforce( HRESULT result, string fn = __FILE__, size_t ln = __LINE__ )
{
	if ( result != S_OK )
    {
        if ( result == CONNECT_E_CANNOTCONNECT )
        {
            MessageBox( null, 
                ( format( "error occured during COM call (0x%X)", result ) ~ "\n" ~ 
                "CONNECT_E_CANNOTCONNECT\n" ~
                fn ~ ": " ~ to!string( ln ) ).toLPWSTR(), 
                "CoEnforce()", MB_ICONEXCLAMATION );
        }
        else if ( result == CONNECT_E_ADVISELIMIT )
        {
            MessageBox( null, 
                ( format( "error occured during COM call (0x%X)", result ) ~ "\n" ~ 
                "CONNECT_E_ADVISELIMIT\n" ~
                fn ~ ": " ~ to!string( ln ) ).toLPWSTR(), 
                "CoEnforce()", MB_ICONEXCLAMATION );
        }
        else
        {
            MessageBox( null, 
                ( format( "error occured during COM call (0x%X)", result ) ~ "\n" ~ 
                to!string( result ) ~ "\n" ~
                fn ~ ": " ~ to!string( ln ) ).toLPWSTR(), 
                "CoEnforce()", MB_ICONEXCLAMATION );
        }
		throw new COMException( result, fn, ln );
    }
}




//
static const size_t clsidLen  = 127;
static const size_t clsidSize = clsidLen + 1;


wstring GUID2wstring( GUID clsid )
{
	//get clsid's as string
	wchar[ clsidLen + 1]  oleCLSID_arr;
	if ( StringFromGUID2( &clsid, oleCLSID_arr.ptr, clsidLen ) == 0 )
		return "";
	wstring oleCLSID = to_wstring( oleCLSID_arr.ptr );
	return oleCLSID;
}


string GUID2string( GUID clsid )
{
	return toUTF8( GUID2wstring( clsid ) );
}


BSTR allocwBSTR(const(wchar)[] s)
{
	return SysAllocStringLen(s.ptr, cast(UINT) s.length);
}

BSTR allocBSTR(string s)
{
	wstring ws = toUTF16(s);
	return SysAllocStringLen(ws.ptr, cast(UINT) ws.length);
}

wstring wdetachBSTR(ref BSTR bstr)
{
	if(!bstr)
		return ""w;
	wstring ws = to_wstring(bstr);
	SysFreeString(bstr);
	bstr = null;
	return ws;
}

string detachBSTR(ref BSTR bstr)
{
	if(!bstr)
		return "";
	wstring ws = to_wstring(bstr);
	SysFreeString(bstr);
	bstr = null;
	string s = toUTF8(ws);
	return s;
}

void freeBSTR(BSTR bstr)
{
	if(bstr)
		SysFreeString(bstr);
}

wchar* wstring2OLESTR(wstring s)
{
	size_t sz = (s.length + 1) * 2;
	wchar* p = cast(wchar*) CoTaskMemAlloc(sz);
	p[0 .. s.length] = s[0 .. $];
	p[s.length] = 0;
	return p;
}

wchar* string2OLESTR(string s)
{
	wstring ws = toUTF16(s);
	size_t sz = (ws.length + 1) * 2;
	wchar* p = cast(wchar*) CoTaskMemAlloc(sz);
	p[0 .. ws.length] = ws[0 .. $];
	p[ws.length] = 0;
	return p;
}

string detachOLESTR(wchar* oleStr)
{
	if(!oleStr)
		return null;

	string s = to_string(oleStr);
	CoTaskMemFree(oleStr);
	return s;
}

unittest
{
	// chinese for utf-8
	string str2 = "\xe8\xbf\x99\xe6\x98\xaf\xe4\xb8\xad\xe6\x96\x87";
	wchar* olestr2 = string2OLESTR(str2);
	string cmpstr2 = detachOLESTR(olestr2);
	assert(str2 == cmpstr2);

	// chinese for Ansi
	wstring str1 = "\ud5e2\ucac7\ud6d0\ucec4"w;
	wchar* olestr1 = wstring2OLESTR(str1);
	string cmpstr1 = detachOLESTR(olestr1);
	wstring wcmpstr1 = toUTF16(cmpstr1);
	assert(str1 == wcmpstr1);
}

wchar* _toLPWSTR(string s)
{
	// const for D2
	return cast(wchar*)toLPWSTR(s);
}

wchar* _toLPWSTRw(wstring s)
{
	// const for D2
	wstring sz = s ~ "\0"w;
	return cast(wchar*)sz.ptr;
}

string to_string(in wchar* pText, size_t iLength)
{
	if(!pText)
		return "";
	string text = toUTF8(pText[0 .. iLength]);
	return text;
}

string to_string(in wchar* pText)
{
	if(!pText)
		return "";
	size_t len = wcslen(pText);
	return to_string(pText, len);
}

wstring to_wstring(in wchar* pText, size_t iLength)
{
	if(!pText)
		return ""w;
	wstring text = pText[0 .. iLength].idup;
	return text;
}

wstring to_cwstring(in wchar* pText, size_t iLength)
{
	if(!pText)
		return ""w;
	wstring text = pText[0 .. iLength].idup;
	return text;
}

wstring to_wstring(in wchar* pText)
{
	if(!pText)
		return ""w;
	size_t len = wcslen(pText);
	return to_wstring(pText, len);
}

wstring to_cwstring(in wchar* pText)
{
	if(!pText)
		return ""w;
	size_t len = wcslen(pText);
	return to_cwstring(pText, len);
}

wstring to_wstring(in char* pText)
{
	if(!pText)
		return ""w;
	size_t len = strlen(pText);
	return toUTF16(pText[0 .. len]);
}

wstring to_tmpwstring(in wchar* pText)
{
	if(!pText)
		return ""w;
	size_t len = wcslen(pText);
	return assumeUnique(pText[0 .. len]);
}

string bstr2string( ref BSTR bstr )
{
    //string s = to!string( bstr[ 0 .. SysStringLen( bstr ) ] );
    //SysFreeString( tagName );
    
	if( !bstr )
		return "";
        
	wstring ws = to_wstring( bstr );
    
	string s = toUTF8( ws );

	return s;
}

///////////////////////////////////////////////////////////////////////
struct ScopedBSTR
{
	BSTR bstr;
	alias bstr this;

	this(string s)
	{
		bstr = allocBSTR(s);
	}
	this(wstring s)
	{
		bstr = allocwBSTR(s);
	}

	~this()
	{
		if(bstr)
		{
			freeBSTR(bstr);
			bstr = null;
		}
	}

	wstring wdetach()
	{
		return wdetachBSTR(bstr);
	}
	string detach()
	{
		return detachBSTR(bstr);
	}
}

