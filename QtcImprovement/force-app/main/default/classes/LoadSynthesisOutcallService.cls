/****************************************************************************************************************
=================================================================================================================
Copyright � 2020 TXU Energy Retail LLC
================================================================================
Purpose:

Referenced By:Search Component
================================================================================
History 
------- 
VERSION		AUTHOR				DATE			DETAIL									PPM/IM/PM
------ -------------- ------------ ---------------------------------------- ----------------
1.0			Prabu Sivagnanam	     	05/31/2022	       Intital version
=================================================================================================================
****************************************************************************************************************/ 
public class LoadSynthesisOutcallService {
      
    public static APIRequestResponseWrapper LoadSynthesisResponse=new APIRequestResponseWrapper();
    public static String errorValue='';
 
    public LoadSynthesisOutcallService()
    {
        errorValue = '';
    }

    @AuraEnabled(cacheable=true)
    public static String sendLoadSynth(String id,Boolean isTest) 
    {
        TXUIntegrationWorker getList = new TXUIntegrationWorker();
        LoadSynthesisResponse.reqPayload='{"id":"'+id+'"}';
        //LoadSynthesisResponse.reqPayload='{"id":"a0405000007br5XAAQ10000"}'; //Testing for error scenario  by giving wrong salesforce id remove it
            
        LoadSynthesisResponse.endPointConfig.Service__c='sf/lbm/txu/rest/vistraRetail/lbm/txu/usage/LoadSynthRequest/'; // as of now hardcoding it,if we do it dynamically then remove this line, for reference in AddressCleanseService 
        getList.endPoint = LoadSynthesisResponse.getUrl.Endpoint__c + LoadSynthesisResponse.endPointConfig.Service__c; 
        getList.CertificateName = LoadSynthesisResponse.getUrl.Certificate__c;
        getList.callLayer7(LoadSynthesisResponse);
        system.debug('endpoint in LoadSynthesisOutcallService : '+getList.endPoint);
            return populateLoadSynthRecommendations();
    }

    @AuraEnabled(cacheable=true)
    public static String downloadUsage(String id,Boolean includeIDR,String requestedUseremail,Boolean isTest)
    {
        TXUIntegrationWorker getList = new TXUIntegrationWorker();
        LoadSynthesisResponse.reqPayload='{"loadSynthID":"'+id+'","includeIDR":"'+includeIDR+'","requestedUseremail":"'+requestedUseremail+'"}';
        //LoadSynthesisResponse.reqPayload='{"id":"a0405000007br5XAAQ10000"}'; //Testing for error scenario  by giving wrong salesforce id remove it
            
        LoadSynthesisResponse.endPointConfig.Service__c='sf/lbm/txu/rest/loadSynthUsageDownload/UsageFromHana'; //'sf/lbm/txu/rest/vistraRetail/lbm/txu/loadSynthUsageDownload/UsageFromHana';
         getList.endPoint = LoadSynthesisResponse.getUrl.Endpoint__c + LoadSynthesisResponse.endPointConfig.Service__c; 
        getList.CertificateName = LoadSynthesisResponse.getUrl.Certificate__c;
        getList.callLayer7(LoadSynthesisResponse);
        system.debug('endpoint in LoadSynthesisOutcallService : '+getList.endPoint);
            return populateLoadSynthRecommendations();
    }

   public static String populateLoadSynthRecommendations()
   {
        try
         {  
             TXUIntegrationWorker theWorker;
             if(LoadSynthesisResponse.responseData != null) 
             {
                 if(LoadSynthesisResponse.checkIsValidResponse()) 
                 {          
                    system.debug('LoadSynthesisResponse in LoadSynthesisOutcallService : ' + LoadSynthesisResponse);   
                    system.debug('LoadSynthesisResponse.responseData in LoadSynthesisOutcallService : ' +LoadSynthesisResponse.responseData);                   

                          
                    if(!LoadSynthesisResponse.checkIsStatusCode500())
                    {
                         //LoadSynthesisResponse.responseData='{"success": "true"}';//LoadSynthesisResponse.responseData='{"error": "true","errorMessage":"Test errorMessage"}'; //Dummy data remove this line 
                         String replaceIllegal= LoadSynthesisResponse.responseData.replaceAll('\n','').replaceAll('\r','');
                         system.debug('replaceIllegal : '+replaceIllegal);
                         JSONParser parser = JSON.createParser(replaceIllegal);

                          // Parse JSON response to get all the  field values.
                         while (parser.nextToken() != null) {
                           if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'error')) {
                               parser.nextToken();
                               errorValue= parser.getText(); 
                               system.debug('errorValue in parser.getText() == error: '+errorValue);                   
                            }
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'errorMessage')) {
                                parser.nextToken();
                                errorValue= parser.getText();       
                                system.debug('errorValue in parser.getText() == errorMessage: '+errorValue);                   
                             }
                             if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Success')) {
                                parser.nextToken();
                                errorValue= '';      
                                system.debug('errorValue in parser.getText() == Success: '+errorValue);                       
                             }
                        }
                    }
                    else{errorValue='Status code is 500';}

                    return errorValue;                
                 }
                 else
                 {
                    system.debug('Invalid Response. Response Code : '+LoadSynthesisResponse.statusCode + ' Message Body :  '+LoadSynthesisResponse.errorMessage);
                    errorValue = 'No Match Found.';
                     theWorker.logException(LoadSynthesisResponse);
                 }
                
                 
             }
             else
             {
                errorValue = 'Invalid Response. Error: No Todos found.';
                 theWorker.logException(LoadSynthesisResponse);
                 
             }             
         }
         catch(Exception theException)
        {
             errorValue = 'Error:'+ theException.getMessage()+'. Please contact your system admin.';
             system.debug('theException.getMessage in LoadSynthesisOutcallService'+theException.getMessage());
         } 
        
         return errorValue;
   }
 


   
}