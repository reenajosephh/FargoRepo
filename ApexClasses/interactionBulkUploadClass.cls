public with sharing class interactionBulkUploadClass {
    public interactionBulkUploadClass() {

    }

    @AuraEnabled
    public static FARGO_Wrapper initiateUpload(Id contentDocumentId)
    {
        FARGO_Wrapper response = new FARGO_Wrapper();
        System.debug('ContentId'+contentDocumentId);
        if(contentDocumentId != null) {    
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            List<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');
             List<Interaction__c> csvMap=convertToRows(csvRecordsList);
             //Map<String,Interaction__c>
           
            System.debug('csvMap>>>'+csvMap);
            System.debug('csvMap>>>>>'+csvMap.size());
            
            if(csvMap!=null){
                
                system.debug('Printing Wrapper'+response);
                response.success=true;
                response.data=csvMap;
                system.debug('Printing Wrapper'+response.success);
                system.debug('Printing Wrapper'+response.data);
                system.debug('Before insert');
                insert csvMap;
                system.debug('After insert');
                
            }
            Database.delete(contentDocumentId);
        }
        return response;
    }
    public static List<Interaction__c> convertToRows(List<String> csvRecordsList){
        Map<String,Interaction__c> csvMap = new Map<String,Interaction__c>();
        List<Interaction__c> interactionFromExcel=new List<Interaction__c>();
        System.debug('csvList>>>>'+csvRecordsList);
        System.debug('csvList>>>>'+csvRecordsList.size());
        if(csvRecordsList!=null)
        {
            
            for(Integer i=1;i<csvRecordsList.size();i++)
            {
                system.debug('i value'+i+csvRecordsList[i]);
                List<String> csvRowData = csvRecordsList[i].split(',');
                if(String.isBlank(csvRowData[0])){
                    break;
                }
                String email = csvRowData[3].trim();
                Interaction__c intobj=new Interaction__c();
    	        intobj.FirstName__c=csvRowData[0];
		        intobj.Last_Name__c=csvRowData[1];
                intobj.Email__c=csvRowData[2];
                intobj.Phone__c=csvRowData[3];
                intobj.Street__c=csvRowData[4];
                intobj.City__c=csvRowData[5];
                intobj.State__c=csvRowData[6];
                intobj.Zip__c=csvRowData[7];
                intobj.Product_of_Interest__c=csvRowData[8];
                intobj.Source__c=csvRowData[9];
               
                interactionFromExcel.add(intobj);
            } 
        }
        return interactionFromExcel;
    }
   @AuraEnabled
    public static void setFlowStatus(boolean value){
        Id userId;
        system.debug(value);
		StopExecutionOfFlow__c obj;
		userId=userinfo.getUserId();
		obj=StopExecutionOfFlow__c.getInstance(userId);
		obj.Stop_Flow__c=value;
		upsert obj;
		system.debug(obj);
        
    }
   
}