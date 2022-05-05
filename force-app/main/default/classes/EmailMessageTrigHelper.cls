public class EmailMessageTrigHelper {
    
    Public Static final string DuplicateCasesQName = (string)email2CaseDeduper__c.getValues('Dedupe').get('queueApiNameDeleteMe__c');   
    Public Static final string DuplicateCasesQid;    
    Public Static final boolean usePe = (boolean)email2CaseDeduper__c.getValues('Dedupe').get('PeDelete__c');  
    Public static final Boolean Usededupe = (Boolean)email2CaseDeduper__c.getValues('Dedupe').get('Deduplication_Active__c');
    Public static set<String> DuplicateCases = New set<string>();
    
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
    
    //DuplicateCases

    Public Static void EmailmessageIteratorBI(List<EmailMessage> messages){
        If(!Usededupe){return;}
        list<EmailMessage> incomingMsg = new list<EmailMessage>();  
        for(emailmessage em :messages){
            if(em.Incoming){   
             incomingMsg.add(em);  
            }
        }      
         incommingEmailmessageIterator(incomingMsg); 
    }
    
    
    Public Static void incommingEmailmessageIterator(List<EmailMessage> messages){
        set<string> originalMsgIds = new set<string>();
        set<string> existingEmIds  = new set<string>();
        set<case> casesToDelete = new set<case>();
        list<DML__e> deletes = new list<DML__e>();
        for(emailmessage em :messages){       
            if(em.Headers != Null){
                Email2caseProcessor(em);
            }
            //saftey net in case headerProcessor method doesn't get run avoids deletion of real cases
            //better to have duplicates than no cases.
            If(em.Email_message_original__c == null){
                em.Email_message_original__c = em.MessageIdentifier;
            }
            If(em.Email_message_original__c !=Null){
                string regExp = '[^a-zA-Z0-9]';
                string s = em.Email_message_original__c.replaceAll(regExp,'').left(50);
                Cache.orgPartition orgPart = Cache.org.getPartition('utilitycache');
                String cachedValue = (String)orgPart.get(s);
                // Check the cache value that the get() call returned.
                if (cachedValue != null) {
                    casesToDelete.add(new case(id = em.ParentId, ownerid = DuplicateCasesQid)); 
                    If(usePe){
                        deletes.add( new DML__e(id__c = em.ParentId, Object__c = 'case', DML_type__c = 'delete'));
                    }
                    
                } else {
                    Cache.Org.put('local.utilitycache.'+s,'exists',300, Cache.Visibility.ALL, true);
                }
            }
            //Check to see if custom setting has deduper set as active
            if((Boolean)email2CaseDeduper__c.getValues('Dedupe').get('Deduplication_Active__c')){
                If(originalMsgIds.contains(em.Email_message_original__c)){
                    casesToDelete.add(new case(id = em.ParentId, ownerid = DuplicateCasesQid));
                    If(usePe){
                        deletes.add( new DML__e(id__c = em.ParentId, Object__c = 'case', DML_type__c = 'delete'));                        
                    }         
                }
                originalMsgIds.add(em.Email_message_original__c);
            }  
        }
        for(emailmessage existingmsg :[select id,subject,Email_message_original__c from emailmessage 
                                       where id != null and Email_message_original__c in :originalMsgIds]){
                                           existingEMIds.add(existingmsg.Email_message_original__c);   
                                       }
        for(emailmessage em :messages){
            If (existingEMIds.contains(em.Email_message_original__c)){
                casesToDelete.add(new case(id = em.ParentId, ownerid = DuplicateCasesQid) );
                If(usePe){
                    deletes.add( new DML__e(id__c = em.ParentId, Object__c = 'case', DML_type__c = 'delete'));   
                }  
            }     
        }
        If(deletes.size()>0){
            List<Database.SaveResult> results = EventBus.publish(deletes);
            return;
        }
        list<case> cases = new list<case>(casesToDelete);
        update cases;
    }
    ////////////////////////////////////////////////////////////////
    Public Static Void Email2caseProcessor(EmailMessage msg){
        System.debug(CaseTrigHelper.pendingRouting);
        If (UtilRecursion.BeenCalled('casetrigger')>0 && CaseTrigHelper.pendingRouting.contains(msg.ParentId)){
            headerProcessor(msg);    
        } 
    }
    ///////////////////////////////////////////////////////////////
    Public static void headerProcessor(emailMessage em){
        string s = em.Headers;
        System.debug(em.Headers);	        
        integer i = s.indexof((string)email2CaseDeduper__c.getValues('Dedupe').get('messageHeaderTofind__c'));
        if(i>1){
            integer start = s.indexOf('<', i);
            integer finish = s.indexOf('>',i)+1;
            string messageid = s.left(finish).right(finish-start);
            em.Email_message_original__c = messageid;   
        }
        Else
        {
            em.Email_message_original__c =  em.MessageIdentifier; 
        } 
    }
    
}
//emailmessage em = [SELECT Headers,Id,MessageIdentifier,ThreadIdentifier FROM EmailMessage where id = '02s4x0000078AMRAA2'limit 1];
//EmailMessageTrigHelper.headerProcessor(em);
