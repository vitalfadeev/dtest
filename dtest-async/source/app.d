import std.stdio;

import core.runtime;
import core.sys.windows.windows;
import std.parallelism : task, taskPool, TaskPool;
import std.conv                 : to;
    
pragma( lib, "user32.lib" ); // MessageBox

enum UINT MSG_ASYNC_WORK_FINISHED = WM_USER + 100;


/*
void FillDataExAsync( string fileName )
{
    // struct A {
    //   shared  bytes[] sharedDataPtr;
    //   AppData appData;
    //   Uno     uno;
    // }
    // A[1] aa;
    // spawn( &worker, fileName, 1 );
    //
    // onReceive( i, {
    //   auto a = aa[i];
    //   a.appData = a.sharedDataPtr;
    //   a.uno.RePaint();
    // } );
    //
    // worker( fileName, i, sharedDataPtr )
    //   sharedDataPtr = bytes[];
    //   send( i, done );
}


class AppData
{
    //
}


class ThreadData( T )
{
    int         id;
    shared( T ) sharedData;
    DG          onSuccess;
    DG          onFail;
}

ThreadData[ tid ] threads;


LRESULT MainLoop()
{
    MSG msg;

    while ( GetMessage( &msg, NULL, 0, 0 ) )
    {
        TranslateMessage( &msg );
        DispatchMessage( &msg );
        
        if ( msg.message == MSG_ASYNC_WORK_FINISHED )
        {
            auto tid = msg.wParam;
            auto threadData = tid in threads;
            
            if ( threadData )
            {
                if ( msg.lParam == S_OK )
                    threadData.onSuccess();
                else
                if ( msg.lParam == S_ERROR )
                    threadData.onFail();
            }
        }
    }

    return msg.wParam;
}


template async( T )( Worker, T sharedData, onSuccess, onFail )
{
    // ThreadData = new ThreadData!( T )();
    
    threadData.sharedData = sharedData;
    threadData.onSuccess  = onSuccess;
    threadData.onFail     = onFail;
    
    auto tid = GetNewTid();
    
    threads[ tid ] = threadData;
    
    th = CreateThread( Worker );
    
    threadData.th = th;
}
*/

void Worker()
{
    import core.thread;
    Thread.sleep( 500.msecs );
    writeln( "Worker()" );
}


void WorkerWrapper( alias WORKER_FUNC )( int tid )
{
    WORKER_FUNC();
    
    // emit Task finished
    // PostThreadMessage( mainThreadId, MSG_ASYNC_WORK_FINISHED, tid, S_OK );
}


auto async( alias FUNC, DG )( DG onSuccess )
{
    threadData.tid       = GetNewTid();
    threadData.onSuccess = onSuccess;

    auto t = task!( WorkerWrapper!FUNC )( tid );
    //taskPool.put( t );
    t.executeInNewThread();
    
    // in msg loop
    // auto fileData = t.yieldForce;
} 


void main()
{
    // auto appData = new AppData();

    // FillDataExAsync();
    
    // async( Worker, workerData, onSuccess, onFail );
    async!Worker(
        {
            writeln( "onSuccess" );
        } 
    );

/*
        .onFail( {
            // onFail
            writeln( "onFail" );
        } );
*/
  
//    writeln( "Data: 1" );
//    writeln( "Data filled: 2" );
}
