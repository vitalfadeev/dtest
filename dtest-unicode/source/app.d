void main()
{
    import std.algorithm            : countUntil;
    import std.algorithm            : find;
    import std.algorithm            : reverse;
    import std.algorithm.comparison : equal;
    import std.array                : array;
    import std.conv                 : to;
    import std.range                : retro;
    import std.range                : take, drop;
    import std.range.primitives     : walkLength;
    import std.stdio                : write, writeln, writef, writefln;
    import std.uni;

    string text = "A\u0308Cᐅ";    // [ A, \u0308, C, ᐅ ]

    // length
    assert(text.walkLength == 4); // 4 code points
    assert(text.length == 7);     // 7 bytes
    
    auto gText = text.Grapheme;

    assert(gText.length == 4);    // 4 graphemes

    // drop
    assert( text          .drop( 1 ).length == 6 ); // length in bytes
    assert( text[]        .drop( 1 ).length == 6 );
    assert( text[ 0 .. $ ].drop( 1 ).length == 6 );
    assert( text.length == 7 );     // 7 bytes

    assert( text          .drop( 3 ).length == 3 ); // | length of 'ᐅ'. bytes
    assert( text[]        .drop( 3 ).length == 3 ); // |
    assert( text[ 0 .. $ ].drop( 3 ).length == 3 ); // |
    assert( text.length == 7 );     // 7 bytes

    assert( text          .drop( 4 ).length == 0 ); // | empty
    assert( text[]        .drop( 4 ).length == 0 ); // |
    assert( text[ 0 .. $ ].drop( 4 ).length == 0 ); // |
    assert( text.length == 7 );     // 7 bytes

    // iterate
    // by byte
    size_t cnt;

    foreach ( c; text ) 
    {
        cnt += 1;
    }
    assert( cnt == 7 );

    // by dchar
    cnt = 0;

    foreach ( dchar c; text ) 
    {
        cnt += 1;
    }
    assert( cnt == 4 );

    // iterate back
    // by byte
    cnt = 0;

    foreach_reverse ( c; text ) 
    {
        cnt += 1;
    }
    assert( cnt == 7 );

    // by dchar
    cnt = 0;

    foreach_reverse ( dchar c; text ) 
    {
        cnt += 1;
    }
    assert( cnt == 4 );

    // std algo
    // find
    size_t pos;  // bytes

    pos = text.length - text.find!"a == 'ᐅ'".length;  // bytes
    assert( pos == 4 ); // bytes

    pos = text.countUntil!"a == 'C'";  // chars
    assert( pos == 2 );                // chars
    pos = text.countUntil!"a == 'ᐅ'";  // chars
    assert( pos == 3 );                // chars

    // find back
    auto r = text.retro.find!"a == 'A'";  // range from 0 to A. includes A. reversed
    r = text.retro.find!"a == 'A'";       // 
    r = r.drop( 1 );                      // skip A: range from 0 to A. excludes A. reversed
    pos = r.array.length;                 // bytes
    assert( pos == 0 );                   // bytes

    r = text.retro.find!"a == 'ᐅ'";       // 
    r = r.drop( 1 );                      // skip ᐅ: range from 0 to ᐅ. excludes ᐅ. reversed
    pos = r.array.length;                 // bytes
    assert( pos == 3 );                   // bytes

    r = text.retro.find!"a == 'C'";       // 
    r = r.drop( 1 );                      // skip C: range from 0 to C. excludes C. reversed
    pos = r.array.length;                 // bytes
    assert( pos == 2 );                   // bytes

    // find back via countUntil
    pos = text.retro.countUntil!"a == 'A'";    // chars back
    assert( text.walkLength == 4 );            // chars
    assert( text.walkLength - pos - 1 == 0 );  // chars

    pos = text.retro.countUntil!"a == 'ᐅ'";    // chars back
    assert( text.walkLength == 4 );            // chars
    assert( text.walkLength - pos - 1 == 3 );  // chars


    // find string back
    text = "ABᐅCDE";
    auto reversed = "ABᐅ".dup.reverse;
    r = text.retro.find( reversed );        // range from 0 to ABᐅ. includes ABᐅ. reversed
    assert( reversed.walkLength == 3 );     // chars
    r = r.drop( reversed.walkLength );      // skip ABᐅ: range from 0 to ABᐅ. excludes ABᐅ. reversed
    pos = r.array.length;                   // bytes
    assert( pos == 0 );                     // bytes

    text = "ABᐅCDE";
    reversed = "ᐅCDE".dup.reverse;
    r = text.retro.find( reversed );        // range from 0 to ABᐅ. includes ABᐅ. reversed
    assert( reversed.walkLength == 4 );     // chars
    r = r.drop( reversed.walkLength );      // skip ABᐅ: range from 0 to ABᐅ. excludes ABᐅ. reversed
    pos = r.array.length;                   // bytes
    assert( pos == 2 );                     // bytes


    // string vs char[]
    string s = "ABC";
    string s2 = s;
    string s3 = s[ 0 .. 2 ];
    assert( s2.ptr == s.ptr);
    assert( s3.ptr == s.ptr);
    //writeln( "string:" );
    //writeln( s.ptr );
    //writeln( s2.ptr );
    //writeln( s3.ptr );

    char[] chars = "ABC".to!(char[]);
    char[] chars2 = chars;
    char[] chars3 = chars[ 0 .. 2 ];
    assert( chars2.ptr == chars.ptr);
    assert( chars3.ptr == chars.ptr);
    //writeln( "chars:" );
    //writeln( chars.ptr );
    //writeln( chars2.ptr );
    //writeln( chars3.ptr );
}

/*
string  narrow ( const wchar_t *s );
wstring widen  ( const char    *s );
string  narrow ( const wstring &s );
wstring widen  ( const string  &s );


vvoid f( const char* name )
{
    HANDLE f = CreateFile( widen( name ).c_str(), GENERIC_WRITE, FILE_SHARE_READ, 0, CREATE_ALWAYS, 0, 0 );

    DWORD written;

    WriteFile( f, "Hello world!\n", 13, &written, 0 );

    CloseHandle( f );
}
*/

