import std.stdio;


interface ISurface
{
    //
}


interface IEvable
{
    void EmitOnKeyDown( ulong code, int repeatCount, int scanCode, ISurface surface, IEvable target );
}


struct Event( ARGS... )
{
    private alias DG = void delegate ( ARGS args );

    struct DGRec
    {
        DG dg;
        void* data;
    }

    DGRec[] _dgs;


    void Connect( DG dg, void* data=null )
    {
        _dgs ~= DGRec( dg, data );
    }

    void DisConnect( DG dg, void* data=null )
    {
        //
    }

    void opAssign( DG dg )
    {
        Connect( dg );
    }

    void Redirect( Event!ARGS toEvent, void* data=null )
    {
        Connect( ( ARGS args ) {
            toEvent( args );
        }, data );
    }

    void opCall( ARGS args )
    {
        foreach( dgrec; _dgs )
            dgrec.dg( args );
    }
}



class Uno : IEvable
{
    this()
    {
        Bind();
    }


    // ulong code, int repeatCount, int scanCode, ISurface surface, IEvable target
    Event!( ulong, int, int, ISurface, IEvable ) onKeyDown;


    // IEvable
    void EmitOnKeyDown( ulong code, int repeatCount, int scanCode, ISurface surface ) 
    {
        writefln( "%s( %s, %s )", __FUNCTION__, surface, this );
        onKeyDown( code, repeatCount, scanCode, surface, this );
    };


    void Bind()
    {
        onKeyDown = 
            ( ulong code, int repeatCount, int scanCode, ISurface surface, IEvable target ) 
            {
                writefln( "Binded: %s( %s, %s )", __FUNCTION__, surface, target );      
            };
    }
}


class WindowSurface : ISurface
{
    void SendEvent( IEvable target )
    {
        ulong    code        = 0x0D;
        int      repeatCount = 0;
        int      scanCode    = 0;
        ISurface surface     = this;
        
        target.EmitOnKeyDown( code, repeatCount, scanCode, surface, target );
    }
}



void main()
{
	auto a = new Uno();
    auto b = new WindowSurface();

    b.SendEvent( a );
}

