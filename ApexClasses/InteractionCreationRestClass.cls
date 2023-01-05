@RestResource(urlMapping='/Interactions/')
global class InteractionCreationRestClass {

    @HttpPost
    global static ID createInteraction(
    string fname,string lname,string email,string phone,string street,
        string city,string state,string pincode,string product,string source)
    {
        Interaction__c intobj=new Interaction__c(
        FirstName__c=fname,
		Last_Name__c=lname,
        Email__c=email,
        Phone__c=phone,
        Street__c=street,
        City__c=city,
        State__c=state,
        Zip__c=pincode,
        Product_of_Interest__c=product,
        Source__c=source,
        GuestOwner__c='guest'
        );
        try{
            system.debug(intobj);
            insert intobj;
        }catch(Exception ex){
            
            system.debug(ex);
        }
        return intobj.id;
    }
}