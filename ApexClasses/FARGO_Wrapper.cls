public with sharing class FARGO_Wrapper {
    public boolean success{get;set;}
    public List<Interaction__c>  data{get;set;}
    public FARGO_Wrapper() {
        success=false;
        data=new List<Interaction__c>();
    }
}