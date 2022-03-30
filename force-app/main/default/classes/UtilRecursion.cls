public class UtilRecursion {

Public static map<String,integer> called = New Map<string,integer>();
    
Public static void resetAll()
    {
    called = New Map<string,integer>();   
    }

////////////////////////////////////////////////////////////
Public static integer numberOfCalls(String Input)
    { 
        If(!called.containsKey(Input))
        {
            return 0;    
        }
        Else
            return called.get(Input);
    }
///////////////////////////////////////////////////////////    
 Public static integer BeenCalled(String Input)
    { 
        If(!called.containsKey(Input))
        {
            called.put(input, 1);   
        }
        Else 
        {
            integer i = Called.get(input);
            I++;
            called.put(input,I);
        }      
        return called.get(input);
    }  
}