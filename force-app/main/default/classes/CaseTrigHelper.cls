public class CaseTrigHelper {
    
    // define the class variables In some cases I an using a final definition
    Public Static final string PendingRoutingQName = (string)email2CaseDeduper__c.getValues('Dedupe').get('QueueNameInbound__c');   
    Public Static final string PendingRoutingQid;    
    Public static set<String> pendingRouting = New set<string>();

    //Static initialization code is a block of code preceded with the keyword static.
    //Similar to other static code, a static initialization code block is only initialized one time on the first use of the class.
	//A class can have any number of either static or instance initialization code blocks. They can appear anywhere in the code body. 
	//The code blocks are executed in the order in which they appear in the file, just as they are in Java.
	//You can use static initialization code to initialize static final variables and to declare information that is static, such as a map of values.
	// I use a single static block to call my variable initilzer methods
    static {
        PendingRoutingQid = PendingRoutingId();
    }   
    
    //This gets the Id value for our Email2CasePendingRouting queue from the cache
    public static string PendingRoutingId() {
        Map<string,String> queueName2IdMap = UtilQueues.getQName2IdMap();
        system.debug(queueName2IdMap.get(PendingRoutingQName));
        return queueName2IdMap.get(PendingRoutingQName);
    }
    
    // This is my iterator method, where possible I iterate over the case object once 
    // This class will so most of the work  by calling other methods.
    // Working in this way  makes it easy to understand the order of operations being done
    // From complex case triggers a proper trigger framework should be emoyed and not helpers.
    Public static void  caseIterator(List<case> cases){
        For(Case c : cases) {
            system.debug('caseIterator');
         addPendingRoutingMembers(c);   
            
        }
    }
     
    Public static void  addPendingRoutingMembers(Case thisCase){
        string owner = thiscase.OwnerId;
        If(owner == PendingRoutingQid) {
        pendingRouting.add(thisCase.Id);   
        }  
        system.debug(pendingRouting);
    }

}