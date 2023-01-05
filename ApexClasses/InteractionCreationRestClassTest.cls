@istest
public class InteractionCreationRestClassTest {
	@istest
	public static void  Test1(){
        
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Interactions'; 
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res; 
        Test.startTest();
            InteractionCreationRestClass.createInteraction(
     'fname','lname','email','string' , 'street','city', 'state', 'pincode', 'product', 'source');
        Test.stopTest();  
    }
}