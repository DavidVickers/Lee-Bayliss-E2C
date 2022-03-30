public class EmailThreading {
    
    // note this calls is not part of deduplication solution, this is part of a solution for when customer is autoresponding to case
    // using marketing cloud or otherwise having to send emails related to a case form outside SF core
    // this code got pulled in by mistake 
    
    public static void threadThis(string msgId, string caseID){
        Emailmessage em = new emailmessage();
        em.Headers = msgId;
        em.MessageIdentifier = msgId;
        em.ParentId = caseID;
        em.RelatedToId = caseId;
        em.Subject = 'Case Place holder';
        em.HtmlBody = 'Not a real Email' ;  
        insert Em;
        
    }

}
