trigger PE_DMLTrigger on DML__e (after insert) {
    
    list<DML__e> inserts = new list<DML__e>();
    list<DML__e> updates = new list<DML__e>();
    list<DML__e> deletes = new list<DML__e>();
    For(DML__e dml : trigger.new){       
        switch on dml.DML_type__c.toLowerCase() {
            when 'insert' {	
                
                inserts.add(dml);
            }	
            when 'update' {		
                updates.add(dml);
            }
            when 'delete' {		// when block 3
                System.debug(dml);
                deletes.add(dml);
            }
            when else {		  // default block, optional
                // code block 4
            }
        }
    }
    
    
    If(deletes.size()>0){
        System.debug(deletes);
        PE_DML_Helper.Deletes(deletes);
    }
}