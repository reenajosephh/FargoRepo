global class InteractionBatch implements Database.batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC) {

        String query = 'SELECT Id,FirstName__c,Last_Name__c,Email__c,Phone__c,Street__c,City__c,State__c,Zip__c,Account__c,Contact__c FROM Interaction__c Where Is_Updated_by_Batch__c=False';

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Interaction__c> scope) {
		List<Contact> conList=DuplicateContactEntries.findDuplicateContact(scope);
        system.debug('Duplicate Contact List'+conList);
        List<Lead> leadList=DuplicateLeadEntries.findDuplicateContact(scope);
         system.debug('Duplicate Lead List'+leadList);
        List<Lead>newLeadList=new List<Lead>();
        
        List<Opportunity>oppList=new List<Opportunity>();
        
        List<Account> accountList=new List<Account>();
        List<ID>accountId=new List<ID>();
        Map<string,Interaction__c> intMap=new Map<string,Interaction__c>();
        //Map<ID,String>contactAccountMap=new Map<ID,String>();
        for(Interaction__c intobj:scope)
        {
            intMap.put(intobj.Email__c,intobj);
        }
         if(conList.size()>0)
        {
            for(Contact conObj:conList)
            {
                accountId.add(conObj.AccountId);
            }
            system.debug('inside if loop for conList size');
            accountList=[SELECT ID,Name ,Phone from Account where ID IN:accountID ];
            system.debug('Scope'+scope);
            for(Contact con:conList){
                system.debug('Printing Map'+intMap);
                if(intMap.containsKey(con.Email))
                {
                    con.FirstName=intMap.get(con.Email).FirstName__c;
                    con.Phone=intMap.get(con.Email).Phone__c;
                    con.MailingStreet=intMap.get(con.Email).Street__c;
                  	
                    for(Account accountobj:accountList)
                    {
                        if(con.AccountId==accountObj.Id)
                        {
                            accountobj.Name=intMap.get(con.Email).FirstName__c;
                            accountobj.Phone=intMap.get(con.Email).Phone__c;
                            accountobj.ShippingStreet=intMap.get(con.Email).Street__c;
                            Opportunity opp=new Opportunity();
                    		opp.CloseDate=system.today();
                    		opp.ContactId=con.Id;
                            opp.AccountId=accountobj.Id;
                    		opp.Name=con.FirstName;
                    		opp.OwnerId=UserInfo.getUserId();
                    		opp.StageName='Prospecting';
                    		oppList.add(opp);
                        }
                    }
                    //Creating Oppourtunity records for updated Contacts
                    /*Opportunity opp=new Opportunity();
                    opp.CloseDate=system.today();
                    opp.ContactId=con.Id;
                    opp.Name=con.FirstName;
                    opp.OwnerId=UserInfo.getUserId();
                    opp.StageName='Prospecting';
                    oppList.add(opp);*/
                }
                for(Interaction__c intobj:scope)
                {
                    intobj.Contact__c=con.Id;
                    intobj.Account__c=con.AccountId;
                    intobj.Is_Updated_by_Batch__c=true;
                }
                
        }
            system.debug('Updated conList'+conList);
            system.debug('Opp list to be inserted'+oppList);
            system.debug('Scope after updating'+scope);
        	update conList;
        	update accountList;
        	insert oppList;
        	update scope;
       
        }
        else if(leadList.size()>0){
            system.debug('inside if loop for list of leads');
            system.debug('Lead List'+leadList);
            system.debug('Scope before lead update'+scope);
            for(Lead leadObj:leadList){
                if(intMap.containsKey(leadObj.Email))
                {
                    leadObj.FirstName=intMap.get(leadObj.Email).FirstName__c;
                    leadObj.Phone=intMap.get(leadObj.Email).Phone__c;
                    leadObj.Street=intMap.get(leadObj.Email).Street__c;
                  	
                }
                for(Interaction__c intobj:scope)
                {
                   
                    intobj.Lead__c=leadObj.Id;
                    intobj.Is_Updated_by_Batch__c=true;
                }
        }
            system.debug('LeadList to be updated'+leadList);
            system.debug('Updated Scope');
        	update leadList;
            update scope;
        }
        else
        {
            system.debug('inside the else part of the loop');
            for(Interaction__c intobj:scope)
            {
            Lead leadObj=new Lead();
            leadObj.Company=intobj.Product_of_Interest__c;
            leadObj.FirstName=intobj.FirstName__c;
            leadObj.LastName=intobj.Last_Name__c;
            LeadObj.Status='Open - Not Contacted' ;
            newLeadList.add(leadObj);
            
            }
            system.debug('The leads to be inserted'+newLeadList);
            insert newLeadList;
            system.debug('The scope without the leads'+scope);
            for(Lead leadobj:newLeadList){
                for(Interaction__c intobj:scope)
                {
                    intobj.Lead__c=leadobj.Id;
                     intobj.Is_Updated_by_Batch__c=true;
                }
            }
            system.debug('The scope with the leads'+scope);
            update scope;
        }
         //update scope;
    }   

    global void finish(Database.BatchableContext BC) {
    }

}