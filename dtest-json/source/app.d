import std.stdio;
import std.json;

void main()
{
    //JSONValue j = parseJSON(`{"name": "D", "kind": "language", "insertMode": true }`);
    JSONValue j;
    j[ "name"       ] = "D";
    j[ "kind"       ] = "language";
    j[ "insertMode" ] = true;

    foreach ( string key, JSONValue value; j )
    {
        writeln( key, ": ", value );
    }
}
