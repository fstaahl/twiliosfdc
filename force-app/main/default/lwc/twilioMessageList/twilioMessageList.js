import { LightningElement, api, wire, track} from 'lwc';
import getPhoneNo from '@salesforce/apex/TwilioMessageListController.getPhoneNo';
import getTwilioMessages from '@salesforce/apex/TwilioMessageListController.getTwilioMessages';
import { getRecord } from 'lightning/uiRecordApi';

export default class TwilioMessageList extends LightningElement {
    @api currentSObjectName;
    @api recordId;
    @track phoneNumber
    @track contactTitle
    @track errorMsg
    @track twilioMessages = [];

    @wire (getRecord, {recordId: '$recordId'})
    record;
   
    renderedCallback() {
        getPhoneNo({
            'sObjectName' : this.currentSObjectName,
            'recordId' : this.recordId
        }).then(result => {
            this.phoneNumber = result;
        }). then(getTwilioMessages({
            'filters' : null
        }).then(result => {
            this.getTwilioMessagesFromJson(result);
        })).catch(error => {
            this.errorMsg = error.message;
        })
    }

    get isError() {
        return this.errorMsg ? true : false;
    }

    getTwilioMessagesFromJson(result) {
        let messageResult = JSON.parse(result);
    
        let twilioMessageArray = [];
    
        messageResult.messages.forEach(message => {
            twilioMessageArray.push(message);
        })
        this.twilioMessages = twilioMessageArray;
    }
}