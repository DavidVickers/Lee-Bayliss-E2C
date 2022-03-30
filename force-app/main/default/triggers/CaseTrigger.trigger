trigger CaseTrigger on Case (before insert,Before update, after insert, after update) {
    
    UtilRecursion.BeenCalled('casetrigger');
    Boolean runTrigger = True;
    If(UtilRecursion.numberOfCalls('UtilEmail2CaseDuplcates.processPendingToRoute') > 0){runTrigger = false;}
 
    System.debug('Should case trigger run? ' + runTrigger);
    if(!runTrigger){return;}
    
    
    If(trigger.isbefore){      
        If(trigger.isinsert){
            System.debug('Case trigger before insert');  
        }
        If(trigger.isupdate){
            System.debug('Case trigger before update');   
        }
    }
    If(trigger.isafter){      
        If(trigger.isinsert){
            CaseTrigHelper.caseIterator(trigger.new);
            System.debug('Case trigger after insert');   
        }
        If(trigger.isupdate){
            System.debug('Case trigger before update');  
        }
    }
}