@isTest
public class InteractionClassTest {
    @isTest
    public static void validateMethod(){
        Test.startTest();
        //I//nteractionClass intobj=new InteractionClass();
        List<Interaction__c> intList=InteractionClass.getInteractionDetails();
        Test.stopTest();
    }
}