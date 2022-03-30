public class UtilEmail2CaseDuplcates {
    
    public Static final string DuplicateCasesQName = (string)email2CaseDeduper__c.getValues('Dedupe').get('queueApiNameDeleteMe__c');   
    public Static final string DuplicateCasesQid;    
    

    //Static initialization code is a block of code preceded with the keyword static.
    //Similar to other static code, a static initialization code block is only initialized one time on the first use of the class.
	//A class can have any number of either static or instance initialization code blocks. They can appear anywhere in the code body. 
	//The code blocks are executed in the order in which they appear in the file, just as they are in Java.
	//You can use static initialization code to initialize static final variables and to declare information that is static, such as a map of values.
	// I use a single static block to call my variable initilzer methods
    static {
        DuplicateCasesQid = DuplicateCasesId();
    }   
    
    //This gets the Id value for our Email2CasePendingRouting queue from the cache
    public static string DuplicateCasesId() {
        Map<string,String> queueName2IdMap = UtilQueues.getQName2IdMap();
        return queueName2IdMap.get(DuplicateCasesQName);
    }
    
    //////////////////////////////////////////////////////////////////////////////
    public Static Void DuplicateEmailcleanup(){
        
        list<case> cases4Deletion = [Select id,ownerId from case where ownerId = :DuplicateCasesQid];
        Delete cases4Deletion;
        
    }
    
    
}