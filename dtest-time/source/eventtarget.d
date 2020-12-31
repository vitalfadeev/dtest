import event : Event;
import event : EventType;
import std.algorithm : remove;


struct EventListener 
{
    void function( Event* event ) handler;


    void handleEvent( Event* event )
    {
        assert( handler !is null, "event handler is null" );

        handler( event );
    }
}


struct EventTarget
{   
    EventListener*[][ EventType ] eventListeners;


    void addEventListener( EventType type, EventListener* listener )
    {
        auto listners = type in eventListeners;

        if ( listners )
        {
            *listners ~= listener;
        }
        else
        {
            eventListeners[ type ] = [ listener ];
        }
    }


    void removeEventListener( EventType type, EventListener* listener )
    {
        auto listeners = type in eventListeners;

        if ( listeners )
        {
            eventListeners[ type ] = ( *listeners ).remove!( ( a ) => a == listener );
        }
    }


    void dispatchEvent( Event* event )
    {
        auto eventType = event.eventType;

        auto listeners = eventType in eventListeners;

        if ( listeners )
        {
            foreach( listener; *listeners )
            {
                listener.handleEvent( event );
            }
        }
    }
}

