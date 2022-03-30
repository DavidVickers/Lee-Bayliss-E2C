public class PE_DML_Helper {
    
    Public static void Deletes(list<DML__e> forDeleting){
        List<sobject> deletes = new list<sobject>();
        For(DML__e dml :forDeleting){
           sObject sObj = Schema.getGlobalDescribe().get(dml.Object__c).newSObject() ;
           sObj.put('id', dml.Id__c);
            System.debug(sobj);
           deletes.add(sObj);
        }
        System.debug(deletes);
        Delete deletes;
    }
        
}