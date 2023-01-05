import { LightningElement,track,api } from 'lwc';
const Endpoint='https://perficient-b3-dev-ed.develop.my.salesforce-sites.com/services/apexrest/Interactions/';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import initiateUpload from '@salesforce/apex/interactionBulkUploadClass.initiateUpload';
import setFlowStatus from '@salesforce/apex/interactionBulkUploadClass.setFlowStatus';
import { NavigationMixin } from 'lightning/navigation';
const POST_METHOD='POST';
const CONTENT_TYPE='application/json';
export default class InputForm extends NavigationMixin(LightningElement){
    
    @track finalList = [];
    failList = [];
    successList = [];
    alreadyUpdateList = [];
    totalRecords;
    failListSize;
    successListSize;
    alreadyUpdateListSize;
    showDownload=true;
    get acceptedFormats() {
        return ['.csv'];
    }
    //for enabling disabling button
    @track enable;
    @track checkboxStatus=false;
    @api FName;
    @track LName;
    @track Email;
    @track Phone;
    @track street;
    @track spinnerStatus =false; //latest changes
    city;
    state;
    @track recordId;

    pincode;
     firstName;
    checkstatus;
    
     
    statusOptions=[
        {value:'Website',label:'Website',description:'Website is product of interest'},
        {value:'Other',label:'Other',description:'Other than website'}
    ];
    
    
    value='new';
   
    handleCheckboxChange(event)
            {
                let checkvalue=false;
                this.checkboxStatus=event.detail.checked;
                console.log(this.checkboxStatus);
                checkvalue=this.checkboxStatus;
            setFlowStatus({value:checkvalue})
            .then(result=>{
                
                console.log(JSON.stringify(this.caseResult));
            })
            .catch(error=>{
               console.log(JSON.stringify(error));
            })
                
                
            }
            

    handleFName(event){
        this.FName=event.target.value;
        console.log('Printing first name'+this.FName);
        }
    handleLName(event){
        this.LName=event.target.value;
        console.log('Printing Last Name'+this.LName);
    }
    handleEmail(event){
        this.Email=event.target.value;
        console.log(this.Email);
    }
    hanlePhone(event){
        this.Phone=event.target.value;
        console.log(this.Phone);
        
    }
    handleCity(event){
        this.city=event.target.value;
        console.log(this.city);
    }
    handleState(event){
        this.state=event.target.value;
        console.log(this.state);
    }
    handlePincode(event){
        this.pincode=event.target.value;
        console.log(this.pincode);
    }
    handleChange(event){
        this.value=event.detail.value;
        console.log('printing combobox'+this.value);
    }
    handleStreet(event){
        this.street=event.target.value;
        console.log(this.street);
    }
    navigateToInteractionPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Interaction__c',
                actionName: 'view'
            }
        });
 }
 
    data=[];
    //New Changes
    isInputValid(){
        let isValid=true;
        let inputFields=this.template.querySelectorAll(".validate");
        inputFields.forEach(inputfield=>{
            if(!inputfield.checkValidity()){
                inputfield.reportValidty();
                isValid=false;
            }
            
        });
        return isValid;
    }
    handleSubmit(event){
        
     let recordData={
        
            fname:this.FName,
            lname:this.LName,
            email:this.Email,
            phone:this.Phone,
            street:this.street,
            city:this.city,
            state:this.state,
            pincode:this.pincode,
            product:this.value,
            source:"Web"
               
            
    }
        this.spinnerStatus=true;
        console.log('In submit part');
        console.log(this.FName);
        console.log(JSON.stringify(this.FName));
        console.log('see the data'+JSON.stringify(recordData));
        console.log(Endpoint);
        console.log('before fetch method');
        let options = {
            method: 'POST',
            headers: {
                'Content-Type':
                    'application/json'
            },
            body: JSON.stringify(recordData)
        }
       //if(this.isInputValid()){
        let fetchRes = fetch("https://perficient-b3-dev-ed.develop.my.salesforce-sites.com/services/apexrest/Interactions/",options);
        console.log(fetchRes);
        fetchRes.then(res =>
            res.json()).then(d => {
                console.log('object id'+d)
                this.checkstatus=d;
                this.spinnerStatus=false;
                this.recordId=d;
                const evt = new ShowToastEvent({
                    title:'Data successfully filled',
                    message:'Data successfully filled',
                    variant:'success',
                });
                this.dispatchEvent(evt);
                
                    this[NavigationMixin.Navigate]({
                        type: 'standard__namedPage',
                        attributes: {
                            pageName: 'home'
                        },
                    });
                

            }).error((error)=>{
                this.spinnerStatus=false;
                console.log('error'+error);
                const evt = new ShowToastEvent({
                    title:'Data not successfully filled',
                    message:'Data not successfully filled',
                    variant:'Error',
                });
                this.dispatchEvent(evt);
            })
        
        if(this.checkstatus!=null){
            console.log('hey from d');
        }   
        var element=this.template.querySelector("form");
        console.log('Element'+element);
        element.reset();
        console.log('after fetch');
        
    }
    showToast(){
        const event = new ShowToastEvent({
            title: 'Toast message',
            message: 'Toast Message',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
     
    handleUploadFinished(event) {
        console.log("accepted 1");
        const uploadedFiles = event.detail.files;
        const temp=event.target.files
        console.log('Event'+JSON.stringify(uploadedFiles));
        const contentId = uploadedFiles[0].documentId;
        initiateUpload( { contentDocumentId : contentId } )
        .then( result => {
            window.console.log('result ===> '+result);
            this.finalList=result.data;  
            window.console.log('finalist'+this.finalList); 
               // this.showDownload=false;
                this.dispatchEvent(
                    new ShowToastEvent( {
                        title: 'Success',
                        message:'Success',
                        variant: 'success'
                    } ),
                );
            

        })
        .catch( error => {
            console.log('Error>>'+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent( {
                    title: 'Error!!',
                    message:'Error',
                    variant: 'error',
                } ),
            );     

        } )
    }
 
}