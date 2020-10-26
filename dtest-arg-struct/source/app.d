import std.stdio;


struct Value
{
    uint type;
    union 
    {
        string valueString;
        int    valueInt;
        float  valueFloat;
    }
    bool modified;

    this( int v )
    {
        type = 1;
        valueInt = v;
    }

    this( string v )
    {
        type = 2;
        valueString = v;
    }
}


struct Keyframe
{
    string name;
    Props  props;
}


struct Props
{
    Value width;
    Value height;
}


void main()
{
    Props p = { width: 1, height: "2" };

	//Keyframe k = 
 //       {
 //           name: "one",
 //           { 
 //               width: 1, 
 //               height: 2 
 //           }
 //       };

 //   Keyframe[] ks = 
 //       [
 //           {
 //               name: "one",
 //               { 
 //                   width: 1, 
 //                   height: 2 
 //               }
 //           },
 //           {
 //               name: "two",
 //               { 
 //                   width: 1, 
 //                   height: 2 
 //               }
 //           }
 //       ];
}



//void AppStyles2()
//{
//    App.styles = 
//    [
//        { 
//            className: "", 
//            {
//                textAlign : "center"
//            } 
//        },

//        { 
//            className: "row", 
//            {
//                display : "block",
//                width   : "100%"
//            }
//        },

//        { 
//            className: "bordered", 
//            {
//                borderWidth : 1,
//                borderColor : 0xFF0000,
//                borderStyle : "solid"
//            }
//        }
//    ];
//}
