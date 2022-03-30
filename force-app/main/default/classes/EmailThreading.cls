public class EmailThreading {
    
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