global class ScheduledCode implements Schedulable {
    global void execute(SchedulableContext SC) {    
        List<CronTrigger> jobs = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger WHERE Id = :sc.getTriggerId()];
        System.debug(jobs);
        list<CronJobDetail> cjds =   [SELECT Id, Name, JobType FROM CronJobDetail WHERE Id = :Jobs[0].CronJobDetail.Id];
        System.debug(cjds);
        //ID jobID = System.enqueueJob(new AsyncfromScheduled(cjds[0]));
        switch on cjds[0].Name {
            when 'ScheduledCode_Min_0' {       
                UtilEmail2CaseDuplcates.DuplicateEmailcleanup();     
            }   
            when 'ScheduledCode_Min_5' {      
                UtilEmail2CaseDuplcates.DuplicateEmailcleanup(); 
            }
            when 'ScheduledCode_Min_10' {       
                UtilEmail2CaseDuplcates.DuplicateEmailcleanup();      
            }
            when 'ScheduledCode_Min_15' {       
                UtilEmail2CaseDuplcates.DuplicateEmailcleanup();
            }
            when 'ScheduledCode_Min_20' {       

                UtilEmail2CaseDuplcates.DuplicateEmailcleanup();
            }        
            when 'ScheduledCode_Min_25' {       
                UtilEmail2CaseDuplcates.DuplicateEmailcleanup();     
            }        
            when 'ScheduledCode_Min_30' {       
                UtilEmail2CaseDuplcates.DuplicateEmailcleanup();               
            }        
            when 'ScheduledCode_Min_35' {       
                UtilEmail2CaseDuplcates.DuplicateEmailcleanup();                
            }        
            when 'ScheduledCode_Min_40' {       
                UtilEmail2CaseDuplcates.DuplicateEmailcleanup();               
            }        
            when 'ScheduledCode_Min_45' {       
                UtilEmail2CaseDuplcates.DuplicateEmailcleanup();              
            } 
            when 'ScheduledCode_Min_50' {       
                UtilEmail2CaseDuplcates.DuplicateEmailcleanup();
            }
            when 'ScheduledCode_Min_55' {       

                UtilEmail2CaseDuplcates.DuplicateEmailcleanup();
            }        
            when else {       // when else block, optional
                // code block 4
            }
        }
    }
    
    public static void setupSchedule(){
        For(integer i = 0 ; i < 60 ; i+=5 ){   
            String sch1 = '0 ' + string.valueOf(i) + ' * * * ?'; 
            ScheduledCode SCR = new ScheduledCode();
            system.schedule('ScheduledCode_Min_' + string.valueOf(i) , sch1, SCR);
        }    
    }
    
    public static void removeSchedule(){
        Set<string> jobNames = new Set<string>();
        For(integer i = 0 ; i < 60 ; i+=5 ){  
            jobNames.add('ScheduledCode_Min_' + string.valueOf(i));   
            
        }
        Map<id,CronJobDetail> chronjobs = new map<id,CronJobDetail>([SELECT Id,JobType,Name FROM CronJobDetail where Name in:jobNames]); 
        for(CronTrigger job :[select id ,CronJobDetailId from CronTrigger where CronJobDetailId in:chronjobs.keyset()] )
        {
            System.abortJob(job.id);
        }
    }
    
}
