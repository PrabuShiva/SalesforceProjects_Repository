/****************************************************************************************************************
=================================================================================================================
Copyright � 2020 TXU Energy Retail LLC
================================================================================
Purpose: 

Referenced By:LoadSynthesis
================================================================================
History 
------- 
VERSION		AUTHOR				DATE			DETAIL									PPM/IM/PM
------ -------------- ------------ ---------------------------------------- ----------------
1.0			Prabu Sivagnanam 	     	05/31/2022	       Intital version
=================================================================================================================
****************************************************************************************************************/ 
public without sharing class LoadSynthesisOutcallController {    
     
    public static LoadSynthesisOutcallService loadSynthService{get;set;}
    public static Map<String,L7_Services__mdt> loadSynthApiEndPoint{get;set;}
    public final static String SERVICENAME = 'LoadSynthRequest'; 
    public static Continuation con = new Continuation(40);

     public LoadSynthesisOutcallController() {
        loadSynthApiEndPoint = new Map<String,L7_Services__mdt>();
        loadSynthService = new LoadSynthesisOutcallService();
        L7_Services__mdt[] endPointConfig = [Select Username__c, Password__c, Request_Type__c,Service__c,Label from L7_Services__mdt where label = :SERVICENAME];
        for(L7_Services__mdt theEndpoint : endPointConfig)
        {
            loadSynthApiEndPoint.put(theEndpoint.label , theEndpoint);
            
        } 

    }
    
      @AuraEnabled 
    public static String processCustomerInfo(String id)
    {
         
        string error = '';
        error = sendLoadSynth(id,false);      

            return error;
    }    

    @AuraEnabled (continuation=true cacheable=true)
   public static String sendLoadSynth(String id,Boolean isTest)
    {
      
        LoadSynthesisOutcallController acc = new LoadSynthesisOutcallController();
        LoadSynthesisOutcallController theCustructor = new LoadSynthesisOutcallController();
        Object continuationObject;
        try
        {
           String error;
            APIRequestResponseWrapper theWrapper = new APIRequestResponseWrapper();
            theWrapper.endPointConfig = loadSynthApiEndPoint.get(SERVICENAME);
          
              theWrapper.getUrl = Outbound_Service_Settings__c.getValues('L7_Endpoint');  
         
            theWrapper.callBackMethod = 'processTodoList';
            LoadSynthesisOutcallService acs = new LoadSynthesisOutcallService();
            LoadSynthesisOutcallService.LoadSynthesisResponse = theWrapper; 
          

            error = LoadSynthesisOutcallService.sendLoadSynth(id,isTest);
           
            
            return error;
        }
        catch(Exception theException)
        {
             throw new AuraHandledException(theException.getMessage());
        }        
    }  

    @AuraEnabled (continuation=true cacheable=true)
    public static String downloadUsage(String id,Boolean includeIDR,String requestedUseremail,Boolean isTest)
     {
       
         LoadSynthesisOutcallController acc = new LoadSynthesisOutcallController();
         LoadSynthesisOutcallController theCustructor = new LoadSynthesisOutcallController();
         Object continuationObject;
         try
         {
            String error;
             APIRequestResponseWrapper theWrapper = new APIRequestResponseWrapper();
             theWrapper.endPointConfig = loadSynthApiEndPoint.get(SERVICENAME);
           
               theWrapper.getUrl = Outbound_Service_Settings__c.getValues('L7_Endpoint');  
          
             theWrapper.callBackMethod = 'processTodoList';
             LoadSynthesisOutcallService acs = new LoadSynthesisOutcallService();
             LoadSynthesisOutcallService.LoadSynthesisResponse = theWrapper; 
           
 
             error = LoadSynthesisOutcallService.downloadUsage(id,includeIDR,requestedUseremail,isTest);
            
             
             return error;
         }
         catch(Exception theException)
         {
              throw new AuraHandledException(theException.getMessage());
         }        
     }  
    
   
 
}