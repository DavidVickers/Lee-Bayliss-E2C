public class UtilQueues {
    
    // First Queue utility is to put a map of Queue names to theri Id's into a cache
    // This allow us to speed up process where we need a queue id which we should not be hard code
    // It also reduces query dependance although this query will periodically run
    // Note If you have a huge number of queue you might exceed the following restriction
    // Maximum size of a single cached item (for put() methods)	100 KB
    // Maximum local cache size for a partition, per-request	500 KB
    // In these case spilt this call ie queues A-M  and N-Z for example
    Public static void cachQnames(){
        Map<string,string> qNametoQid = new Map<string,string>();
        for(group g : [SELECT Id,Name FROM Group WHERE Type = 'Queue']){
            qNametoQid.put(g.name,g.id);    
        }
        Cache.Org.put('local.utilitycache.queueName2IdMap',qNametoQid,172800, Cache.Visibility.ALL, true);
    }
    
    // The next method is here  to retreive on demand a map of queue names to their Ids
    // It the cache has no current Queue map then this mthod handles the miss and repolulates the cache
    // Note we are implementing the more complex put statment put(key, value, ttlSecs, visibility, immutable)
    Public static Map<string,String> getQName2IdMap(){
        Cache.OrgPartition orgPart = Cache.Org.getPartition('local.utilitycache');
        Map<string,String> queueName2IdMap = (Map<string,String>)orgPart.get('queueName2IdMap');
        System.debug(queueName2IdMap);
        if (queueName2IdMap != null) {
            return queueName2IdMap;  
        } else {
            cachQnames();
            orgPart = Cache.Org.getPartition('local.utilitycache');
            return (Map<string,String>)orgPart.get('queueName2IdMap');  
        }     
    }
    
}