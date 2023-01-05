@isTest
public class DuplicateLeadEntriesTest {
@testSetup static void setup() {
      Interaction__c intobj=new Interaction__c();
    	intobj.FirstName__c='Reena';
		intobj.Last_Name__c='Joseph';
        intobj.Email__c='enujoseph9@gmail.com';
        intobj.Phone__c='1234567';
        intobj.Street__c='abc';
        intobj.City__c='pune';
        intobj.State__c='Maharashtra';
        intobj.Zip__c='411013';
        intobj.Product_of_Interest__c='Website';
        intobj.Source__c='Web';
    
    	insert intobj;
    	//List<Interaction__c> intList=new List<Interaction__c>();
    	//intList.add(intobj);  
              
    }
    @isTest 
     static void testMethod1(){
      List<Interaction__c> intList=[Select FirstName__c ,Id,Last_Name__c,Email__c,Phone__c,Street__c,City__c,State__c,Zip__c,Product_of_Interest__c,Source__c from Interaction__c Limit 1 ];
      DuplicateLeadEntries.findDuplicateContact(intList);
    }
}