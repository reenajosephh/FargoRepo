public class DuplicateLeadEntries {
@InvocableMethod(label='Get Related Leads' description='Find duplicate records when a new interaction record is created')
    public static List<Lead> findDuplicateContact(List<Interaction__c> intnList){
        
        List<Lead> conList=new List<Lead>();
        List<Lead>duplicateList=new List<Lead>();
        List<String>email=new List<String>();
        List<String>lastName=new List<String>();
        List<Lead>dupeLead=new List<Lead>();
        for(Interaction__c intobj :intnList){
            Lead con=new Lead();
            con.FirstName=intobj.FirstName__c;
            con.LastName=intobj.Last_Name__c;
            con.Email=intobj.Email__c;
            //conList=findDuplicate(con);
            email.add(intobj.Email__c);
            lastName.add(intobj.Last_Name__c);
            /*if(conlist.size()==0)
            {
                duplicateList.add(null);
            }
            else
            {
                duplicateList.add(conList[0]);
            }*/
        }
        dupeLead=[Select Id,FirstName,LastName,Email from Lead where LastName IN :lastName AND Email IN:email];
        if(dupeLead.size()==0)
            {
                duplicateList.add(null);
            }
            else
            {
                duplicateList.add(dupeLead[0]);
            }
        return duplicateList;
    }
    /*public static List<sObject> findDuplicate(Lead con){
        List<sObject> conList=new List<sObject>();
        conList.add(con);
        
        //List<Datacloud.FindDuplicatesResult> findduplicateResult=Datacloud.FindDuplicates(conList);
        List<Datacloud.DuplicateResult> duplicateresults;
        
        List<Datacloud.FindDuplicatesResult> findduplicateresult;
        findduplicateresult=Datacloud.FindDuplicates.findDuplicates(conList);
        Datacloud.DuplicateResult duplicateResult=findduplicateresult.get(0).getDuplicateResults().get(0);
        Datacloud.MatchResult matchResult=duplicateResult.getMatchResults()[0];
        List<Datacloud.MatchRecord> matchRecords= matchResult.getMatchRecords();
        
        List<sObject> duplicates=new List<sObject>();
        for(Datacloud.MatchRecord matchRecord:matchRecords)
        {
            sObject duplicate=matchRecord.getRecord();
            System.debug('Match Record'+duplicate);
            duplicates.add(duplicate);
        }
        System.debug(duplicates.size());
        return duplicates;
            }*/
}