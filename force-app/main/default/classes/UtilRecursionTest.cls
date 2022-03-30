@IsTest
public class UtilRecursionTest {


   @IsTest  static void recursionTest()  
    {
      system.equals(0,UtilRecursion.numberOfCalls('Testme'));  
      system.equals(1,UtilRecursion.BeenCalled('Testme'));
      system.equals(1,UtilRecursion.numberOfCalls('Testme'));  
      system.equals(2,UtilRecursion.BeenCalled('Testme'));    
      UtilRecursion.ResetAll();  
      system.equals(0,UtilRecursion.numberOfCalls('Testme'));  
      system.equals(1,UtilRecursion.BeenCalled('Testme'));
      system.equals(1,UtilRecursion.numberOfCalls('Testme'));  
      system.equals(2,UtilRecursion.BeenCalled('Testme'));            
    }     
}