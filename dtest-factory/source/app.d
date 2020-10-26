import std.stdio;


struct RECT
{
    int x;
    int y;
    int w;
    int h;
}

alias uint  COLOR;


interface ICalculated
{
    void GetCalculatedRelativeRect( RECT* rect );
    COLOR GetCalculatedForeColor();
    COLOR GetCalculatedBackColor();
}


interface IEvable
{
    //
}


interface ISurface
{
    //
}


interface ISurfaceHolder
{
    ISurface GetSurface();
    @property void surface( SurfaceFactoryFunc v );
    @property void surface( ISurface v );
}


alias ISurface function( RECT* rect, COLOR foreColor, COLOR backColor, IEvable evable ) SurfaceFactoryFunc;


class WindowSurface : ISurface
{
    this( RECT* rect, COLOR foreColor, COLOR backColor, IEvable evable ) 
    {
        //
    }
}


ISurface WindowSurfaceFactory( RECT* rect, COLOR foreColor, COLOR backColor, IEvable evable )
{
    return new WindowSurface( rect, foreColor, backColor, evable );
}


SurfaceFactoryFunc Window()
{
    return &WindowSurfaceFactory;
}


class UnoWindow : ICalculated, IEvable, ISurfaceHolder
{
    this()
    {
        surface = Window;
    }


    // ISurfaceHolder
    private ISurface _surface;
    private SurfaceFactoryFunc _surfaceFactory;

    ISurface GetSurface()
    {
        if ( _surface is null )
        {
            if ( _surfaceFactory )
            {
                RECT rc;
                GetCalculatedRelativeRect( &rc );
                _surface = _surfaceFactory( &rc, GetCalculatedForeColor(), GetCalculatedBackColor(), this );
            }
        }

        return _surface;
    }

    @property void surface( SurfaceFactoryFunc v ) { _surfaceFactory = v; }
    @property void surface( ISurface v )          { _surface = v;        }


    // ICalculated
    void GetCalculatedRelativeRect( RECT* rect ) {}
    COLOR GetCalculatedForeColor() { return 0xFFFFFF; }
    COLOR GetCalculatedBackColor() { return 0x000000; }
}


void main()
{
    auto a = new UnoWindow();

	writeln("Edit source/app.d to start your project.");
}

