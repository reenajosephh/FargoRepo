import { LightningElement,track,wire } from 'lwc';
import getInteractionDetails from '@salesforce/apex/InteractionClass.getInteractionDetails';

const COLS=[

    {label:'Interaction Name',fieldName:'Name',type:'text'},
    {label:'Created Date',fieldName:'CreadtedDate',type:'date'},
  ];
export default class TopTenInteraction extends LightningElement {
    columns=COLS;
    @track interactions = [];
    @wire(getInteractionDetails)
    wiredInteractions({error,data}) {
        if(error){
            console.log(error);
            console.log('Oops error found!');
        }
        else if(data){
            console.log('Reena data'+data);
            let newData=[];
            console.log(data);
            data.forEach(record=>{
                let recordData={};
                if(record.Contact__c){
                    recordData.Name=record.Name;
                    recordData.CreadtedDate=record.CreatedDate;

                    newData.push(recordData);
                }
                else if(record.Lead__c){
                    recordData.Name=record.Name;
                    recordData.CreadtedDate=record.CreatedDate;
                    newData.push(recordData);
                }
                else{
                    recordData.Name=record.Name;
                    recordData.CreadtedDate=record.CreatedDate;
                    newData.push(recordData);
                }
            })
            console.log(newData);
            this.interactions=newData;
            console.log(this.interactions);
        }
    }

}