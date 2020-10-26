import std.stdio;
import std.math : round;
import std.conv : to;
import math : RoundedDiv;
import std.math : rint;


void RunBenchmark()
{
    import std.stdio;
    import std.datetime.stopwatch;
    auto t = benchmark!(
            RunBenchmarkFloat, 
            RunBenchmarkInt,
            )(1000_000);
    writeln("-----");
    writeln("float :   ", t[0]);
    writeln("int   :   ", t[1]);
}


void RunBenchmarkFloat()
{
    auto x = RoundedDiv( 59, 4 );
}


void RunBenchmarkInt()
{
    auto x = RoundedDiv( 59.9f, 4.0f );
}


void main()
{
    RunBenchmark();
}

