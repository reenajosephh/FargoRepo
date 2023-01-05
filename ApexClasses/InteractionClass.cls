public class InteractionClass {
    @AuraEnabled(cacheable=true)
    public static List<Interaction__c> getInteractionDetails() {

        return[SELECT ID ,Name,CreatedDate,Contact__r.Name,GuestOwner__c,FirstName__c,Last_Name__c,
        Lead__r.Name from Interaction__c WHERE GuestOwner__c='Guest'
        ORDER BY CreatedDate Desc
        LIMIT 10
        ];
        //removed where condition where OwnerId=: Userinfo.getUserId()
        //WITH SECURITY_ENFORCED
    }
}