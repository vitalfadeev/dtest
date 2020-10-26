import std.stdio;
import std.conv : to;
import loop : Loop;
import loop : LoopForEach;


struct POINT
{
    int x;
    int y;
}

enum int LENGTH = 1024;

static POINT[ LENGTH ] arr;


void main()
{
    Loop loop;
    loop.Loop();
    
    LoopForEach loopForEach;
    loopForEach.LoopForEach();

    assert( loopForEach.array[ 0 ] == 1 );
}


void FillArray()
{
        foreach( i; 0 .. arr.length )
        {
            arr[ i ].x = i.to!int;
        }
}

/+
struct Array
{
    enum int LENGTH = 1024;
    int[ LENGTH ] arr;

    int IndexOf( int a )
    {
        version ( X86_64 )
        {
            IndexOf_X86_64( a );
        }
        else
        {
            IndexOf_Generic( a );
        }
    }


    pragma( inline )
    int IndexOf_X86_64( int a )
    {
        // rep scas: 2n + 45
        //
/*
        asm {
            // Load
            mov     rcx, LENGTH;

            // Check for zero-length
            jcxz    zero_length;

            mov     rax, [ a ];
            mov     es,  [ arr.ptr ];
            mov     rdi, [ arr.ptr ];
            cld;    // DF flag == 0. Forward direction.

            // Loop
            repne; 
            scasd;
            jne     fail;

            // OK
            mov     eax, ecx;
            ret;

            ; Fail
        fail;
        zero_length:
            mov     eax, -1;
            ret;
        }
*/
    }

    pragma( inline )
    int IndexOf_Generic( int a )
    {
        int* itemPtr = arr.ptr;

        for ( int cx = arr.length; cx > 0; cx--, itemPtr++ )
        {
            if ( *itemPtr == a ) 
            {
                return arr.length - cx;
            }
        }

        return -1;
    }
}
+/
