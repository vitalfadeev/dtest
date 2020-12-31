void main()
{
    import std.range : SortedRange, assumeSorted;
    import std.stdio: write, writeln, writef, writefln;
    import std.algorithm.sorting : sort;

    size_t[] lines  = [ 20, 1755, 1756, 1757, 1798, 1824, 1825, 1839, 1840 ];
    size_t   search = 21;
    auto     r = assumeSorted!( "a < b" )( lines );

    auto l = r.lowerBound(search);
    auto e = r.equalRange(search);
    auto u = r.upperBound(search);
    auto f = r.trisect(search);
    
    writeln(l);
    writeln(f[0]);

    writeln(e);
    writeln(f[1]);

    writeln(u);
    writeln(f[2]);
}
