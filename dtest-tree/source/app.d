/** Data Source */
import std.path  : dirName;
import std.stdio : writeln;
import direntry  : DirEntry;
import direntry  : DirIterator;
import std.algorithm : sort;
import std.typecons;

/** Tree */
struct Entry( T )
{
    /** */
    InputRange!T childs()
    {
        return [];
    }

    /** */
    Tuple!( bool, T ) parent()
    {
        return tuple( false, T() );
    }
}


void main()
{
    import std.array     : array;
    import std.algorithm : sort;

    auto node = DirEntry( r"C:\src" );
    writeln( "node: ", node );
    writeln( "node.parent: ", node.parent );

    auto sorted = 
        node
            .childs
            .array
            .sort!( 
                ( a, b ) => ( 
                    ( a.isDir && b.isFile ) ||
                    ( a.isDir && b.isDir && a.name < b.name ) ||
                    ( a.isFile && b.isFile && a.name < b.name )
                ) 
            );

    foreach ( child; sorted )
    {
        writeln( child );
    }
}


unittest
{
    auto node = DirEntry( r"C:\" );

    assert( node.parent().hasParent == false );
}

unittest
{
    auto node = DirEntry( r"C:\" );

    foreach ( child; node.childs )
    {
        writeln( child );
    }
}

