import std.ascii : isAlphaNum;
import std.algorithm.iteration : chunkBy, joiner, map;
import std.algorithm.mutation : copy;
import std.conv : to;
import std.demangle : demangle;
import std.functional : pipe;
import std.stdio : stdin, stdout;

void main()
{
    stdin.byLineCopy
        .map!(
            l => l.chunkBy!(a => isAlphaNum(a) || a == '_')
                  .map!(a => a[1].pipe!(to!string, demangle)).joiner
        )
        .copy(stdout.lockingTextWriter);
}
