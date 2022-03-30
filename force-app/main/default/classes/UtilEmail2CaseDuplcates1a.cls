public class UtilEmail2CaseDuplcates1a {
    
    // define the class variables In some cases I an using a final definition
    public static final string PendingRoutingQName = 'Email2CasePendingRouting'; 
    public static final string Ready4RoutingQName = 'ReadyToRoute';  
    public static final string PendingRoutingQid;
    public static final string Ready4RoutingQid;
    public static final integer minutesOffset = 5;
    Public static final boolean simplerouting = true;
    //Public static set<String> pendingRouting= New set<string>();
    
    //Static initialization code is a block of code preceded with the keyword static.
    //Similar to other static code, a static initialization code block is only initialized one time on the first use of the class.
    //A class can have any number of either static or instance initialization code blocks. They can appear anywhere in the code body. 
    //The code blocks are executed in the order in which they appear in the file, just as they are in Java.
    //You can use static initialization code to initialize static final variables and to declare information that is static, such as a map of values.
    // I use a single static block to call my variable initilzer methods
    static {
        PendingRoutingQid= pendingRoutingId();
        Ready4RoutingQid = ready4RoutingId();
    }   
    
    //This gets the Id value for our Email2CasePendingRouting queue from the cache
    public static string ready4RoutingId() {      
        map<string,String> queueName2IdMap = UtilQueues.getQName2IdMap();
        return queueName2IdMap.get(Ready4RoutingQName);
    }
    
    public static string PendingRoutingId() {      
        map<string,String> queueName2IdMap = UtilQueues.getQName2IdMap();
        return queueName2IdMap.get(PendingRoutingQName);
    }
    /////////////////////////////////////////////////////////////////////////////
    public static void processPendingToRoute(){
    UtilRecursion.BeenCalled('UtilEmail2CaseDuplcates1a.processPendingToRoute');   
    List<emailmessage> ready2Route =  UtilEmail2CaseDuplcates1a.deleteDuplicateMessagesAndCases(UtilEmail2CaseDuplcates1a.getRoutableMessages());
	System.debug(ready2Route);
    routeEmailCases(ready2Route);
        
    }
    
    //////////////////////////////////////////////////////////////////////////////
    public static map<String,List<emailMessage>> getRoutableMessages(){
        // set up the variables wee will need
        datetime now  = system.now();
        set<string> caseIds = new set<string>();
        map<String,List<emailMessage>> mapMsgId2listMsgs = new map<String,List<emailMessage>>();
        // To make this effiecient I am using a map of a Map 
        // The booelan is used to set if the list of eamil messages is routable ie is the Oldest member of any given list over
        // minutesOffset value (5min at the time of writing the comments)
        map<string,map<boolean,List<emailMessage>>> MsgId2BoolListMsgs = new map<string,map<boolean,List<emailMessage>>>();
        for(Case c : [Select id, ownerid from case where ownerid = :PendingRoutingQid]){
            caseIds.add(c.id);
        }
        //Now get all the Email messages where their ParentId is in the set of Case Ids form above
        list<emailmessage> messages = [select id,createdDate,parentId,FromAddress,ToAddress,subject,CcAddress,BccAddress,Email_message_original__c,messageIdentifier 
                                       from emailmessage where Incoming = true and parentId in:CaseIds];
        //Now we iterate note the custome field Email_message_original__c will be very important and is set when the email messages record is created from the 
        //headers we cannot use MessageIdentifier because email to case goes through a middle man eg an outlook email address that redirects the message into the 
        //SFDC service address. Because of this each Messages identifier will be different for each service email address do wee need the original messagesid which 
        //will be common
        for(emailmessage em :messages){ 
            // set a boolean place holder
            Boolean readyToRoute = false;
            //change it to true of the messsage in question is minutesOffset (5 min example) older that the time now
            If(now.addMinutes(-minutesOffset) > em.createdDate){
                readyToRoute = true;    
            }
            // the next part simeply completes the complex map work throu it and it should be easy enough to follow
            if(MsgId2BoolListMsgs.containskey(em.Email_message_original__c)){
                List<emailMessage> msgs = new List<emailMessage>();   
                map<Boolean,List<emailMessage>> bool2listMsgs =  MsgId2BoolListMsgs.get(em.Email_message_original__c);
                If(bool2listMsgs.containskey(true)) {
                    msgs = bool2listMsgs.get(true);
                }else{
                    msgs = bool2listMsgs.get(false);
                }
                msgs.add(em);
                bool2listMsgs.put(readyToRoute,msgs);
                MsgId2BoolListMsgs.put(em.Email_message_original__c,bool2listMsgs); 
            }else{
                List<emailMessage> msgs = new List<emailMessage>{em};
                    map<Boolean,List<emailMessage>> bool2listMsgs = new map<Boolean,List<emailMessage>>{readyToRoute => msgs};
                        MsgId2BoolListMsgs.put(em.Email_message_original__c,bool2listMsgs);               
            }   
        }
        //Now we have our completed complex map we can iterat over it and pull ou just the lists of messages where the oldest in each group is older
        //than minutesOffset (5min)
        for(string s :MsgId2BoolListMsgs.keySet()){
            if(MsgId2BoolListMsgs.get(s).containskey(true)){
            mapMsgId2listMsgs.put(s,MsgId2BoolListMsgs.get(s).get(true));   
            }
        }
        // return a map Original Messages Ids (Email_message_original__c) to the list of Messages (all the copies of the same message)
        return mapMsgId2listMsgs;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    public static list<emailmessage> deleteDuplicateMessagesAndCases(map<String,List<emailMessage>> mapmsgs){
        // This method simpley takes the result from above and deletes and extra emails and cases
        list<emailmessage> delmessages = new list<emailmessage>();
        list<emailmessage> messages = new list<emailmessage>();
        list<case> delcases = new list<case>();
        for(string s :mapmsgs.keyset()){
            integer i = 0;
            for(emailmessage em :mapmsgs.get(s)){
                if(i>0){   
                delmessages.add(new emailmessage(id = em.id));
                delcases.add(new case (id = em.ParentId));    
                }
                else
                {
                messages.add(em);   
                }
                i++;
            }
        }
        delete delmessages;
        delete delCases;
        return messages;
    }
    /////////////////////////////////////////////////////////////////////////////////////////////
    public static void routeEmailCases(list<emailmessage> messages){
        // this method for not just changes the owner to Ready for Routing  
        // Routing logic will also be handled here later
        list<case> updatecases = new list<case>();
        System.debug(Ready4RoutingQid);
        for(emailmessage em :messages){                      
            If(simplerouting){
            System.debug('simple routing engaged');   
            updateCases.add(new case (id = em.ParentId, Ownerid = Ready4RoutingQid));    
            }
            Else
            {
                
            }    
        }
        System.debug(updateCases);
        Update updateCases;
    }
    
}