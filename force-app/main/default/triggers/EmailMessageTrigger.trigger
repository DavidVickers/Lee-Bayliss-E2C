trigger EmailMessageTrigger on EmailMessage (before insert,Before update, after insert, after update) {
    UtilRecursion.BeenCalled('emailmessagetrigger');
    
    public class MyException extends Exception {}
    If(trigger.isbefore){      
        If(trigger.isinsert){
            System.debug('EmailMessage trigger before insert'); 
           EmailMessageTrigHelper.EmailmessageIteratorBI(trigger.new);
            
        }
        If(trigger.isupdate){
            System.debug('EmailMessage trigger before update');   
        }
    }
    If(trigger.isafter){      
        If(trigger.isinsert){
            System.debug('EmailMessage trigger after insert'); 
            
        }
        If(trigger.isupdate){
            System.debug('EmailMessage trigger after update');  
        }
    }
}