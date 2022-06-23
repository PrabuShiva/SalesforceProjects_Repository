/****************************************************************************************************************
=================================================================================================================
Copyright � 2020 TXU Energy Retail LLC
================================================================================
Purpose: Actions used in LoadSynthesis Process

Referenced By:LoadSynthesis(LWC Component)
================================================================================
History 
------- 
VERSION     AUTHOR              DATE            DETAIL                                  PPM/IM/PM
------ -------------- ------------ ---------------------------------------- ----------------
1.0         Prabu Sivagnanam        05/24/2022   Intital version
=================================================================================================================
****************************************************************************************************************/ 
public class LoadSynthesisController {
    @InvocableVariable public String errorMessage;
    public static Boolean validationCleared=true;
    @InvocableVariable public list<String> errorMessageList=new list<String>();
    @InvocableVariable public String LoadSynthesisId;


    /******************************Submit_LoadSynthesis-Start*****************************************/ 
  
    @Auraenabled
    public static string insert_LoadSynthesis(String EstimationType,String AnnualMWh,String IndustryType,String ZipCode,String Channel,String essids,String SqFootofPremise,String EmplyforBus,String YearInBus,boolean IDRFlag,String MonthlyUsage)
    {    
        LoadSynthesisController loadSynthesisResponse = new LoadSynthesisController();
        loadSynthesisResponse.errorMessageList=null; 
        try
        {           
        loadSynthesisResponse.errorMessageList=validate(EstimationType,AnnualMWh,IndustryType,ZipCode,Channel,essids,SqFootofPremise,EmplyforBus,YearInBus,IDRFlag,MonthlyUsage);
        if(LoadSynthesisController.validationCleared==false){return JSON.serialize(loadSynthesisResponse);} 

       
       LoadSynthesis__c ls=new LoadSynthesis__c();
        ls.Status__c='Draft';//'Submitted to Load Synthesis';
        ls.Estimation_Type__c=EstimationType;
        ls.Annual_MWh__c=AnnualMWh;
        ls.Channel__c= Channel;
        ls.Esiids__c=essids;
        ls.Industry_Type__c=IndustryType;
        if(!String.isEmpty(MonthlyUsage) ) {ls.Monthly_Usage__c=usageDateCalculation(MonthlyUsage);}
        
        if(EstimationType == 'TOSA'){
            ls.No_of_Employee_for_Bus__c= EmplyforBus == '0' ? '3':EmplyforBus;
            ls.Sq_Foot_of_Premise__c= SqFootofPremise == '0' ? '4':SqFootofPremise;
            ls.Years_in_Business__c= YearInBus == '0' ? '1':YearInBus;
        }else{
            ls.No_of_Employee_for_Bus__c= EmplyforBus;
            ls.Sq_Foot_of_Premise__c= SqFootofPremise;
            ls.Years_in_Business__c= YearInBus;
        }
        ls.ZipCode__c=ZipCode;
        ls.IDR_Flag__c=IDRFlag;
        insert ls; 
        loadSynthesisResponse.LoadSynthesisId=ls.Id;
        
        return JSON.serialize(loadSynthesisResponse);

        }
       catch (Exception ex) {
        list<String> errorMessageList=new list<String>();
        errorMessageList.add(ex.getMessage());
        loadSynthesisResponse.errorMessageList=errorMessageList;
        return JSON.serialize(loadSynthesisResponse);
         }

    }   
    /******************************Submit_LoadSynthesis-End*****************************************/

    /*******************************DownloadUsage-Part Start*********************************/ 
    @Auraenabled
    public static string insert_LoadSynthesisForDownloadUsage(String essids)
    {    
        LoadSynthesisController loadSynthesisResponse = new LoadSynthesisController();
        loadSynthesisResponse.errorMessageList=null; 
        try 
        {           
      
        if(String.isEmpty(essids)){
            list<String> errorMessageList=new list<String>();
            errorMessageList.add(label.ESIIDsRequired);
            loadSynthesisResponse.errorMessageList=errorMessageList;
            LoadSynthesisController.validationCleared=false;
         }

        if(LoadSynthesisController.validationCleared==false){return JSON.serialize(loadSynthesisResponse);} 

       
       LoadSynthesis__c ls=new LoadSynthesis__c();
        ls.Status__c='Submitted for Usage Download';//'Submitted to Load Synthesis';
        ls.Esiids__c=essids;
       
        insert ls; 
        loadSynthesisResponse.LoadSynthesisId=ls.Id;
        
        return JSON.serialize(loadSynthesisResponse);

        }
       catch (Exception ex) {
        list<String> errorMessageList=new list<String>();
        errorMessageList.add(ex.getMessage());
        loadSynthesisResponse.errorMessageList=errorMessageList;
        return JSON.serialize(loadSynthesisResponse);
         }

    }   

    public  static list<String> validate(String EstimationType,String AnnualMWh,String IndustryType,String ZipCode,String Channel,String essids,String SqFootofPremise,String EmplyforBus,String YearInBus,boolean IDRFlag,String MonthlyUsage ) {
   
        LoadSynthesisController.validationCleared=true;
        list<String> errorMessageList=new list<String>();

        if(String.isEmpty(EstimationType)){

        errorMessageList.add(label.EstimationTypeRequired);
        LoadSynthesisController.validationCleared=false;

       }
    if((EstimationType=='TOSA' || EstimationType=='CUSTOM' || String.isEmpty(EstimationType)) && (String.isEmpty(Channel))){

        errorMessageList.add(label.ChannelRequired);
        LoadSynthesisController.validationCleared=false;

    }
    if(String.isEmpty(IndustryType)){   
        errorMessageList.add(label.IndustryTypeRequired);
        LoadSynthesisController.validationCleared=false;
    }
    if(String.isEmpty(ZipCode)){
        errorMessageList.add(label.ZipCodeRequired);
        LoadSynthesisController.validationCleared=false;
    }
    else if(ZipCode.isNumeric()==false || ZipCode.length()!=5){
        errorMessageList.add(label.ZipCodeNumber);
        LoadSynthesisController.validationCleared=false;
    }
    if(String.isEmpty(essids)){
       errorMessageList.add(label.ESIIDsRequired);
       LoadSynthesisController.validationCleared=false;
    }

    if(Channel=='BDR' || Channel=='Key/National'|| Channel=='Third Party'){
        if((String.isEmpty(AnnualMWh)) && (String.isEmpty(MonthlyUsage) ) ) 
        {
            errorMessageList.add(label.AMWhorMonthlyUsageRequired);
            LoadSynthesisController.validationCleared=false;
        }
    }
    if(!String.isEmpty(AnnualMWh)){
    if(AnnualMWh.isNumeric()==false){
        errorMessageList.add(label.EstimatedAMWhRequired);
        LoadSynthesisController.validationCleared=false;
    }
    }
    /***********Monthly usage validation - start */
    if(!String.isEmpty(MonthlyUsage) ) {
    list<String> MeterReadEndDatewithKwhList=  MonthlyUsage.split('#');
    for (String MeterReadEndDatewithKwh : MeterReadEndDatewithKwhList)
    {           
        list<String> DateandKwh =  MeterReadEndDatewithKwh.split(':');         
        if(DateandKwh.size()==2 && DateandKwh[0]!='null'){

            if(DateandKwh[1].isNumeric()==false){                    
                LoadSynthesisController.validationCleared=false;
                errorMessageList.add(label.KWhNumber);
                return errorMessageList;
            }          
        }
        else if(DateandKwh.size()==2 && DateandKwh[0]=='null'){               
            LoadSynthesisController.validationCleared=false;
            errorMessageList.add(label.MeterReadEndDateAndrespectiveKWh);
            return errorMessageList;
        }
        else if(DateandKwh.size()==1 && DateandKwh[0]!='null'){               
            LoadSynthesisController.validationCleared=false;
            errorMessageList.add(label.MeterReadEndDateAndrespectiveKWh);
            return errorMessageList;
        }
        
    }
}
/***********Monthly usage validation - End */


    return errorMessageList;
    }

    /******************************validate-End*****************************************/

    /******************************usageDateCalculation-Start*****************************************/
    public  static String usageDateCalculation(String MeterReadEndDatewithKwhInput) {
   
        String MeterReadStartDateEndDatewithKwhInput='';
        list<String> MeterReadEndDatewithKwhList=  MeterReadEndDatewithKwhInput.split('#');
        for (String MeterReadEndDatewithKwh : MeterReadEndDatewithKwhList)
        {
            list<String> DateandKwh =  MeterReadEndDatewithKwh.split(':');
            Date dt =date.valueOf(DateandKwh[0]);
            Integer day = dt.Day(); //get day
            Integer month = dt.Month(); //get month
            Integer year = dt.Year(); //get year 

            if(day>=16){
                day=1;
            }else{
                day=1;
                if(month>1){month=month-1;} else{month=12;year=year-1;}
            }
            string startdate=year+'-'+month+'-'+day;
            String temp=startdate+':'+DateandKwh[0]+':'+DateandKwh[1]+'#';
            MeterReadStartDateEndDatewithKwhInput=MeterReadStartDateEndDatewithKwhInput+temp;
        }
    return MeterReadStartDateEndDatewithKwhInput;
    }

    /******************************usageDateCalculation-End*****************************************/

       /*******************************DownloadUsage-Part Start*********************************/ 
       @Auraenabled
       public static string sendDatatoBoomi(string id){  //refer the class AddressCleanseService
       //do callout here rest or soap
   
       LoadSynthesisController loadSynthesisResponse = new LoadSynthesisController();
       loadSynthesisResponse.errorMessageList=null;   
       list<String> errorMessageList=new list<String>();
       
         //  try
         //  {
               
       
       String error=LoadSynthesisOutcallController.processCustomerInfo(id);
       if(error!=''){ errorMessageList.add(label.BoomiFailure_GenericErrorMessage); }     //Unable to process the request, Please contact System Admin
       else if(error==''){
           LoadSynthesis__c ls =[select id,Status__c from LoadSynthesis__c where id =: id limit 1];
           ls.Status__c='Submitted to Load Synthesis';
           update ls;
   
       }
       loadSynthesisResponse.errorMessageList=errorMessageList;
       return JSON.serialize(loadSynthesisResponse);
   
        /*   }
          catch (Exception ex) {
           
              errorMessageList.add(ex.getMessage());
              loadSynthesisResponse.errorMessageList=errorMessageList;
           return JSON.serialize(loadSynthesisResponse);
            }*/
       }
   
       @Auraenabled
       public static string sendDatatoBoomiForDownloadUsage(String id){  
       
        LoadSynthesis__c ls =[select id,IDR_Flag__c from LoadSynthesis__c where id =: id limit 1];
        User usr = [SELECT ID, email FROM User WHERE ID = :UserInfo.getUserId()];
       //do callout here rest or soap
   
       LoadSynthesisController loadSynthesisResponse = new LoadSynthesisController();
       loadSynthesisResponse.errorMessageList=null;   
       list<String> errorMessageList=new list<String>();
       
         //  try
         //  {
               
       //Send true always to download IDR data also if available
       String error=LoadSynthesisOutcallController.downloadUsage(id,true,usr.email,false);
       if(error!=''){ errorMessageList.add(label.BoomiFailure_GenericErrorMessage); }     //Unable to process the request, Please contact System Admin
      /* else if(error==''){
           LoadSynthesis__c ls =[select id,Status__c from LoadSynthesis__c where id =: id limit 1];
           ls.Status__c='Submitted to Load Synthesis';
           update ls;
   
       }*/
       loadSynthesisResponse.errorMessageList=errorMessageList;
       return JSON.serialize(loadSynthesisResponse);
   
        /*   }
          catch (Exception ex) {
           
              errorMessageList.add(ex.getMessage());
              loadSynthesisResponse.errorMessageList=errorMessageList;
           return JSON.serialize(loadSynthesisResponse);
            }*/
       }
    
}