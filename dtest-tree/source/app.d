/** Data Source */
import std.path  : dirName;
import std.stdio : writeln;
import direntry  : DirEntry;
import direntry  : DirIterator;
import std.algorithm : sort;


/** Tree */
struct TreeNode( T )
{
    /** */
    InputRange!T childs()
    {
        return [];
    }

    /** */
    T parent()
    {
        return null;
    }
}


/** */
struct FileTreeNode
{
    DirEntry dirEntry;
    alias dirEntry this;


    /** */
    bool parent( out FileTreeNode node )
    {
        auto parentPath = dirEntry.name.dirName;

        if ( parentPath && ( parentPath != dirEntry.name ) )
        {
            node = FileTreeNode( DirEntry( parentPath ) );
            return true;
        }
        else
        {
            return false;
        }
    }


    /** */
    //FileTreeNode[] childs()
    auto childs()
    {
        return DirIterator( dirEntry.name );
    }
}


void main()
{
    import std.array     : array;
    import std.algorithm : sort;

    auto node = FileTreeNode( DirEntry( r"C:\src" ) );
    writeln( "node: ", node );
    FileTreeNode pn;
    writeln( "node.parent: ", node.parent( pn ), ", ", pn );

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
    auto node = FileTreeNode( r"C:\" );

    FileTreeNode par;
    assert( node.parent( par ) == false );
}

unittest
{
    auto node = FileTreeNode( r"C:\" );

    foreach ( child; node.childs )
    {
        writeln( child );
    }
}

