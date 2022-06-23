/****************************************************************************************************************
=================================================================================================================
Copyright � 2020 TXU Energy Retail LLC
================================================================================
Purpose: To Upload Essids from user

Referenced By:SubFlow_ESIID_Usage_Information,lWCESIIDUsageInfoParent
================================================================================
History 
------- 
VERSION AUTHOR DATE DETAIL PPM/IM/PM
------ -------------- ------------ ---------------------------------------- ----------------

=================================================================================================================
****************************************************************************************************************/

import { LightningElement, api, wire,track} from "lwc";
import {FlowNavigationNextEvent,FlowNavigationBackEvent} from 'lightning/flowSupport';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import { getPicklistValues } from "lightning/uiObjectInfoApi";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import LoadSynthesis_OBJECT from "@salesforce/schema/LoadSynthesis__c";

import insert_LoadSynthesis from "@salesforce/apex/LoadSynthesisController.insert_LoadSynthesis";
import insert_LoadSynthesisForDownloadUsage from "@salesforce/apex/LoadSynthesisController.insert_LoadSynthesisForDownloadUsage";
import sendDatatoBoomi from "@salesforce/apex/LoadSynthesisController.sendDatatoBoomi";
import sendDatatoBoomiForDownloadUsage from "@salesforce/apex/LoadSynthesisController.sendDatatoBoomiForDownloadUsage";

import EstimationType_Field from "@salesforce/schema/LoadSynthesis__c.Estimation_Type__c";
import Channel_Field from "@salesforce/schema/LoadSynthesis__c.Channel__c";
import IndustryType_Field from "@salesforce/schema/LoadSynthesis__c.Industry_Type__c";
import Estimated_AMWh_Field from "@salesforce/schema/LoadSynthesis__c.Annual_MWh__c";
import Sq_Foot_Field from "@salesforce/schema/LoadSynthesis__c.Sq_Foot_of_Premise__c";
import Years_Field from "@salesforce/schema/LoadSynthesis__c.Years_in_Business__c";
import No_of_Employee_Field from "@salesforce/schema/LoadSynthesis__c.No_of_Employee_for_Bus__c";




export default class loadSynthesis extends NavigationMixin(LightningElement) {
    @api LoadSynthesisrecord;
    @api LoadSynthesisId;
    @api errorMessage=null;
    @api errorMessageforDownloadUsage=null;

    @track _Page1='Yes';
    @track _Page2=null;
    @track _Page3=null;

    @track _Page1_DownloadUsage='Yes';
    @track _Page2_DownloadUsage=null;
    @track _Page3_DownloadUsage=null;
   // @track _isLighting = true;
   // @track _TosaOrCustom = false;
    @track _isLighting = false;
    @track _TosaOrCustom = true;
    @track _EstimationType;
    @track _IDRFlag = false;
    @track _AnnualMWh=null;
    @track _IndustryType;
    @track _ZipCode;
    @track _Channel;
    @track _essids;
    @track _essidsforDownloadUsage;
    @track _SqFootofPremise=0;
    @track _EmplyforBus=0;
    @track _YearInBus=0;
    @track _MonthlyUsage=null;


    @wire(getObjectInfo, { objectApiName: LoadSynthesis_OBJECT })
    objectInfo;
  
    @wire(getPicklistValues, {
      recordTypeId: "$objectInfo.data.defaultRecordTypeId",
      fieldApiName: EstimationType_Field
    })
    EstimationType_Field_PicklistValues;

    @wire(getPicklistValues, {
      recordTypeId: "$objectInfo.data.defaultRecordTypeId",
      fieldApiName: Channel_Field
    })
    Channel_Field_PicklistValues;
    /** */
    @wire(getPicklistValues, {
      recordTypeId: "$objectInfo.data.defaultRecordTypeId",
      fieldApiName: Estimated_AMWh_Field
    })
    Estimated_AMWh_Field_PicklistValues;
    @wire(getPicklistValues, {
      recordTypeId: "$objectInfo.data.defaultRecordTypeId",
      fieldApiName: Sq_Foot_Field
    })
    Sq_Foot_Field_PicklistValues;
    @wire(getPicklistValues, {
      recordTypeId: "$objectInfo.data.defaultRecordTypeId",
      fieldApiName: Years_Field
    })
    Years_Field_PicklistValues;
    @wire(getPicklistValues, {
      recordTypeId: "$objectInfo.data.defaultRecordTypeId",
      fieldApiName: No_of_Employee_Field
    })
    No_of_Employee_Field_PicklistValues;
    /** */

    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: IndustryType_Field
      })
      IndustryType_Field_PicklistValues;



    handleChange(event) {
        this.areDetailsVisible = event.target.checked;
    }
    renderedCallback(){
      this._IDRFlag = false;
        this._AnnualMWh=null;
        console.log('_IDRFlag renderedCallback : ' + this._IDRFlag);
        console.log('_AnnualMWh renderedCallback : ' + this._AnnualMWh);
    }
    
    connectedCallback() {
        console.log('Connected CallBack Called');
        this._Page1='Yes';this._Page2=null;this._Page3=null;
/*
        getLoadSynthesis({LoadSynthesisrecId: this.LoadSynthesisId })
          .then((result) => {
            this.LoadSynthesisrecord = result;
          })
          .catch(() => {

          });
    
    */
      }

      handleChange_EstimationType(evt) {
        this._EstimationType = evt.target.value;
        if(this._EstimationType==="TOSA" || this._EstimationType==="CUSTOM"){
          this._isLighting = false;
          this._TosaOrCustom = true;
          if(this._IndustryType === 'LIGHTING'){ this._IndustryType = '';}
        }
        else{
          this._isLighting = true;
          this._TosaOrCustom = false;         
          this._Channel ='LIGHTING'; 
          this._IndustryType = 'LIGHTING'
        }
      }

      handleChange_IDRFlag(evt) {
        if(this._IDRFlag===true){this._IDRFlag=false; }
        else if(this._IDRFlag===false){this._IDRFlag=true;}
      }

     
      handleChange_AnnualMWh(evt) {
        this._AnnualMWh = evt.target.value;
      }
      handleChange_IndustryType(evt) {
        this._IndustryType = evt.target.value;
      }
      handleChange_ZipCode(evt) {
        this._ZipCode = evt.target.value;
      }
      handleChange_Channel(evt) {
        this._Channel = evt.target.value;
      }
      handleChange_essids(evt) {
        this._essids = evt.target.value;
      }
      handleChange_essidsforDownloadUsage(evt) {
        this._essidsforDownloadUsage = evt.target.value;
      }
      handleChange_SqFootofPremise(evt) {
        this._SqFootofPremise = evt.target.value;
      }
      handleChange_EmplyforBus(evt) {
        this._EmplyforBus = evt.target.value;
      }
      handleChange_YearInBus(evt) {
        this._YearInBus = evt.target.value;
      }
   

/***For Usage****/
keyIndex = 0;
@track itemList = [
    {
        id: 0
    }
];

/*addRow() {
    ++this.keyIndex;
    var newItem = [{ id: this.keyIndex }];
    this.itemList = this.itemList.concat(newItem);
}*/
addRow(event) {
  var index =event.target.accessKey;
  ++this.keyIndex;
  var newItem = [{ id: this.keyIndex }];
  var itemListTemp = [
    {
        id: 0
    }
];
  for(let i=0; i<this.itemList.length; i++){
    var currentItem=this.itemList[i];

    if(i==0){itemListTemp[0]=currentItem;} else {itemListTemp=itemListTemp.concat(currentItem);}

    if(currentItem.id==index){
      itemListTemp=itemListTemp.concat(newItem);
    }
}
this.itemList = itemListTemp;

}


removeRow(event) {
    if (this.itemList.length >= 2) {
        this.itemList = this.itemList.filter(function (element) {
            return parseInt(element.id) !== parseInt(event.target.accessKey);
        });
    }
}

handleSubmit() {

    var AllMonthUSage='';
    var isVal = true;
    this.errorMessage ='';
    this.template.querySelectorAll('lightning-input-field').forEach(element => {
        isVal = isVal && element.reportValidity();
    });
    if (isVal) {
          
            this.template.querySelectorAll('lightning-input').forEach(element => {
              if(element.value!=='' && element.value!==null ){ 

              if(element.name==='MeterReadEndDate'){
                AllMonthUSage=AllMonthUSage+element.value+':';
              }
              if(element.name==='KWh'){
                  AllMonthUSage=AllMonthUSage+element.value+'#';
                }

              }

            });
 
    } 

    if(this._Channel==='none'){
      this._Channel='';
    }

    insert_LoadSynthesis({    
      EstimationType: this._EstimationType,
      AnnualMWh: this._AnnualMWh,
      IndustryType: this._IndustryType, 
      ZipCode: this._ZipCode, 
      Channel: this._Channel, 
      essids: this._essids, 
      SqFootofPremise: this._SqFootofPremise, 
      EmplyforBus: this._EmplyforBus, 
      YearInBus: this._YearInBus, 
      IDRFlag: this._IDRFlag,
      MonthlyUsage: AllMonthUSage

  })
    .then((result) => {
      var errorMessageValue=null;
      this.LoadSynthController_Parsing_Response = JSON.parse(result);

      const keys = Object.keys(this.LoadSynthController_Parsing_Response);

      for (const key of keys) {
          if (key === "errorMessageList") {
          errorMessageValue = this.LoadSynthController_Parsing_Response[key];
         
        }

        if (key === "LoadSynthesisId") {
          this.LoadSynthesisRecordId = this.LoadSynthController_Parsing_Response[key];
         
        }
      }
      this.errorMessage = errorMessageValue;
        
      if(this.errorMessage.length===0){ 
      this.errorMessage='';

 /*     this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.LoadSynthesisRecordId,
            objectApiName: 'LoadSynthesis__c',
            actionName: 'view'
        }
    });*/
    this._Page1=null;this._Page2='Yes';

      }
    })
    .catch((error) => {});
}
 

handleFinish() {
    

  sendDatatoBoomi({    
    id: this.LoadSynthesisRecordId

})

.then((result) => {
  var errorMessageValue=null;
  this.LoadSynthController_Parsing_Response = JSON.parse(result);

  const keys = Object.keys(this.LoadSynthController_Parsing_Response);

  for (const key of keys) {
    //alert(key);
      if (key === "errorMessageList") {
      errorMessageValue = this.LoadSynthController_Parsing_Response[key];
     
    }

  }
  //alert(errorMessageValue); 
 
  this.errorMessage = errorMessageValue;
 // alert('this.errorMessage.length : '+this.errorMessage.length);

  if(this.errorMessage.length===0){ 
  this.errorMessage='';


    /*********Toast Message */
    const event = new ShowToastEvent({
      title: 'Success',
      message: 'Successfully submitted to Loadsynth',
      variant: 'success',
      mode: 'dismissable'
  });
  this.dispatchEvent(event);
   /*********Toast Message */
    /*********Redirecting to the record */
     this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId: this.LoadSynthesisRecordId,
        objectApiName: 'LoadSynthesis__c',
        actionName: 'view'
    }
    });
    /*********Redirecting to the record */
//this._Page1=null;this._Page2='Yes';
  }
  if(this.errorMessage.length>0){this._Page1=null;this._Page2=null;this._Page3='Yes';}
  else{
    this._Page1='Yes';this._Page2=null;this._Page3=null;
  }
})
.catch((error) => {});

}

/*******************************DownloadUsage-Part Start*********************************/ 
handleSubmitforDownloadUsage() { 

  insert_LoadSynthesisForDownloadUsage({       
    essids: this._essidsforDownloadUsage
})
  .then((result) => {
    var errorMessageValue=null;
    this.LoadSynthController_Parsing_Response = JSON.parse(result);

    const keys = Object.keys(this.LoadSynthController_Parsing_Response);

    for (const key of keys) {
        if (key === "errorMessageList") {
        errorMessageValue = this.LoadSynthController_Parsing_Response[key];
       
      }

      if (key === "LoadSynthesisId") {
        this.LoadSynthesisRecordId = this.LoadSynthController_Parsing_Response[key];
       
      }
    }
    this.errorMessageforDownloadUsage = errorMessageValue;
      
    if(this.errorMessageforDownloadUsage===null){
    this.errorMessageforDownloadUsage='';
    this._Page1_DownloadUsage=null;this._Page2_DownloadUsage='Yes';
  

    }
  })
  .catch((error) => {});
}

handleFinishForDownloadUsage() {
  this.errorMessageforDownloadUsage =null;

  sendDatatoBoomiForDownloadUsage({    
    id: this.LoadSynthesisRecordId

})

.then((result) => {
  var errorMessageValue=null;
  this.LoadSynthController_Parsing_Response = JSON.parse(result);

  const keys = Object.keys(this.LoadSynthController_Parsing_Response);

  for (const key of keys) {
    //alert(key);
      if (key === "errorMessageList") {
      errorMessageValue = this.LoadSynthController_Parsing_Response[key];
     
    }

  }
  //alert(errorMessageValue); 
 
  this.errorMessageforDownloadUsage = errorMessageValue;

  if(this.errorMessageforDownloadUsage.length===0){ 

  this.errorMessageforDownloadUsage='';


    /*********Toast Message */
    const event = new ShowToastEvent({
      title: 'Success',
      message: 'Successfully submitted the request for Esiid Download Usage, Usage data will be uploaded in few seconds',
      variant: 'success',
      mode: 'dismissable'
  });
  this.dispatchEvent(event);
   /*********Toast Message */
    /*********Redirecting to the record */
     this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId: this.LoadSynthesisRecordId,
        objectApiName: 'LoadSynthesis__c',
        actionName: 'view'
    }
    });
    /*********Redirecting to the record */
  }
  if(this.errorMessageforDownloadUsage.length>0){this._Page1_DownloadUsag=null;this._Page2_DownloadUsag=null;this._Page3_DownloadUsag='Yes';}
  else{
    this._Page1_DownloadUsag='Yes';this._Page2_DownloadUsag=null;this._Page3_DownloadUsag=null;
  }
})
.catch((error) => {});

}

/*******************************DownloadUsage-Part End*********************************/ 

}