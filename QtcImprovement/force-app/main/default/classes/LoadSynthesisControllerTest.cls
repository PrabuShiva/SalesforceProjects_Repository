/****************************************************************************************************************
=================================================================================================================
Copyright � 2020 TXU Energy Retail LLC
================================================================================
Purpose: Test Class for LoadSynthesisController
================================================================================
History 
------- 
VERSION    AUTHOR            DATE      DETAIL                  PPM/IM/PM
------ -------------- ------------ ---------------------------------------- -----------------
1.0      Prabu    05/24/2022      Intital version
=================================================================================================================
****************************************************************************************************************/ 
@isTest
public class LoadSynthesisControllerTest
{
    private class ResponseMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"success": "true"}');
            res.setStatusCode(200);
            res.setStatus('SUCCESS');
            return res;
        }
    }

    public static User testUser;
    static void setupData()
    {    

        testUser =  utilTestMethods.setupUser('ABC', 'Cloud Solutions Sys Admin', 'All Accounts');

        OutboundRequestConfiguration__c ORC = new OutboundRequestConfiguration__c();
        ORC.Name ='LoadSynthesis';
        ORC.EndpointUrl__c ='/sf/lbm/txu/rest/VistraRetail/LBM/TXU/loadSynthesis/';
        ORC.ObjectName__c ='LoadSynthesis__c';
        ORC.FieldsToSend__c='Id';
        insert ORC;

    }
   
      public static testMethod void submitLoadSynthesisWithNoData() 
    {
        setupData();
        
        String EstimationType;
        String AnnualMWh;
        String IndustryType;
        String ZipCode;
        String Channel;
        String essids;
        String SqFootofPremise;
        String EmplyforBus;
        String YearInBus;
        boolean IDRFlag;
        String MonthlyUsage;

    
        Test.startTest();
        System.runAs(testUser)
        {
            LoadSynthesisController.insert_LoadSynthesis(EstimationType,AnnualMWh,IndustryType,ZipCode,Channel,essids,SqFootofPremise,EmplyforBus,YearInBus,IDRFlag,MonthlyUsage);
           //List<QuoteWizardDealController> output= QuoteWizardDealController.submitQuoteInfoAndProceedToStep4(input1);
           // System.assertEquals(1,output[0].ipq.Number_Of_ESIIDs__c, 'Number_Of_ESIIDs should be one while validations failed');
        }
        Test.stopTest();
    }

    public static testMethod void submitLoadSynthesisWithAllData() 
    {
        setupData();
        
        String EstimationType='TOSA';
        String AnnualMWh='25';
        String IndustryType='CHURCHES';
        String ZipCode='75001';
        String Channel='BDR';
        String essids='111111111111';
        String SqFootofPremise='100000+';
        String EmplyforBus='10+';
        String YearInBus='10+';
        boolean IDRFlag=false;
        String MonthlyUsage='2022-5-1:2022-05-27:11#';

        Test.setMock(HttpCalloutMock.class, new ResponseMock());
        Test.startTest();
        System.runAs(testUser)
        {
            LoadSynthesisController.insert_LoadSynthesis(EstimationType,AnnualMWh,IndustryType,ZipCode,Channel,essids,SqFootofPremise,EmplyforBus,YearInBus,IDRFlag,MonthlyUsage);
           //List<QuoteWizardDealController> output= QuoteWizardDealController.submitQuoteInfoAndProceedToStep4(input1);
           // System.assertEquals(1,output[0].ipq.Number_Of_ESIIDs__c, 'Number_Of_ESIIDs should be one while validations failed');
        }
        Test.stopTest();
        
        
    }

    public static testMethod void submitLoadSynthesisWithAllDatawithValidationErrors() 
    {
        setupData();
        
        String EstimationType='TOSA';
        String AnnualMWh='25';
        String IndustryType='CHURCHES';
        String ZipCode='7500X';
        String Channel='BDR';
        String essids='111111111111';
        String SqFootofPremise='100000+';
        String EmplyforBus='10+';
        String YearInBus='10+';
        boolean IDRFlag=false;
        String MonthlyUsage='2022-5-1:2022-05-27:11#';

        Test.setMock(HttpCalloutMock.class, new ResponseMock());
        Test.startTest();
        System.runAs(testUser)
        {
            String returnMessage=LoadSynthesisController.insert_LoadSynthesis(EstimationType,AnnualMWh,IndustryType,ZipCode,Channel,essids,SqFootofPremise,EmplyforBus,YearInBus,IDRFlag,MonthlyUsage);
            //System.assertEquals('Zip Code should be a 5 digit Number',returnMessage.errorMessageList[0], 'Number_Of_ESIIDs should be one while validations failed');

        }
        Test.stopTest();
        
        
    }
    public static testMethod void submitLoadSynthesisWithAllDatawithValidationErrors2() 
    {
        setupData();
        
        String EstimationType='TOSA';
        String AnnualMWh='25';
        String IndustryType='CHURCHES';
        String ZipCode='7500X';
        String Channel='BDR';
        String essids='111111111111';
        String SqFootofPremise='100000+';
        String EmplyforBus='10+';
        String YearInBus='10+';
        boolean IDRFlag=false;
        String MonthlyUsage='2022-5-1:2022-05-27:11#';

        Test.setMock(HttpCalloutMock.class, new ResponseMock());
        Test.startTest();
        System.runAs(testUser)
        {
            //ZipCode='7500X';Channel='BDR';AnnualMWh='25';MonthlyUsage='2022-5-1:2022-05-27:11#';
            Channel='BDR';AnnualMWh='AAA';MonthlyUsage='2022-5-1:#';//Non-numeric value for AnnualMWh & MonthlyUsage while Channel is BDR
            String returnMessage=LoadSynthesisController.insert_LoadSynthesis(EstimationType,AnnualMWh,IndustryType,ZipCode,Channel,essids,SqFootofPremise,EmplyforBus,YearInBus,IDRFlag,MonthlyUsage);
            
          
        }
        Test.stopTest();
        
        
    }
    public static testMethod void submitLoadSynthesisWithAllDatawithValidationErrors3() 
    {
        setupData();
        
        String EstimationType='TOSA';
        String AnnualMWh='25';
        String IndustryType='CHURCHES';
        String ZipCode='7500X';
        String Channel='BDR';
        String essids='111111111111';
        String SqFootofPremise='100000+';
        String EmplyforBus='10+';
        String YearInBus='10+';
        boolean IDRFlag=false;
        String MonthlyUsage='2022-5-1:2022-05-27:11#';

        Test.setMock(HttpCalloutMock.class, new ResponseMock());
        Test.startTest();
        System.runAs(testUser)
        {
            //ZipCode='7500X';Channel='BDR';AnnualMWh='25';MonthlyUsage='2022-5-1:2022-05-27:11#';
            ZipCode='7500X';Channel='BDR';AnnualMWh='';MonthlyUsage='2022-05-27:null#'; //Empty value for AnnualMWh & MonthlyUsage while Channel is BDR
            String returnMessage=LoadSynthesisController.insert_LoadSynthesis(EstimationType,AnnualMWh,IndustryType,ZipCode,Channel,essids,SqFootofPremise,EmplyforBus,YearInBus,IDRFlag,MonthlyUsage);
       
        }
        Test.stopTest();
        
        
    }
    public static testMethod void submitLoadSynthesisWithAllDatawithValidationErrors4() 
    {
        setupData();
        
        String EstimationType='TOSA';
        String AnnualMWh='25';
        String IndustryType='CHURCHES';
        String ZipCode='7500X';
        String Channel='BDR';
        String essids='111111111111';
        String SqFootofPremise='100000+';
        String EmplyforBus='10+';
        String YearInBus='10+';
        boolean IDRFlag=false;
        String MonthlyUsage='2022-5-1:2022-05-27:11#';

        Test.setMock(HttpCalloutMock.class, new ResponseMock());
        Test.startTest();
        System.runAs(testUser)
        {
            ZipCode='7500X';Channel='BDR';AnnualMWh='';MonthlyUsage='null:25#'; //Empty value for AnnualMWh & MonthlyUsage while Channel is BDR
            String returnMessage=LoadSynthesisController.insert_LoadSynthesis(EstimationType,AnnualMWh,IndustryType,ZipCode,Channel,essids,SqFootofPremise,EmplyforBus,YearInBus,IDRFlag,MonthlyUsage);
            
        }
        Test.stopTest();
        
        
    }
     public static testMethod void submitLoadSynthesisWithCustomData() 
    {
        setupData();
        
        String EstimationType='Custom';
        String AnnualMWh='25';
        String IndustryType='CHURCHES';
        String ZipCode='75001';
        String Channel='BDR';
        String essids='111111111111';
        String SqFootofPremise='100000+';
        String EmplyforBus='10+';
        String YearInBus='10+';
        boolean IDRFlag=false;
        String MonthlyUsage='2022-5-1:2022-05-27:11#';

        Test.setMock(HttpCalloutMock.class, new ResponseMock());
        Test.startTest();
        System.runAs(testUser)
        {
            LoadSynthesisController.insert_LoadSynthesis(EstimationType,AnnualMWh,IndustryType,ZipCode,Channel,essids,SqFootofPremise,EmplyforBus,YearInBus,IDRFlag,MonthlyUsage);
           //List<QuoteWizardDealController> output= QuoteWizardDealController.submitQuoteInfoAndProceedToStep4(input1);
           // System.assertEquals(1,output[0].ipq.Number_Of_ESIIDs__c, 'Number_Of_ESIIDs should be one while validations failed');
        }
        Test.stopTest();
        
        
    }
    
        public static testMethod void insert_LoadSynthesisForDownloadUsageTest() 
    {
        setupData();
        
        String EstimationType='TOSA';
        String AnnualMWh='25';
        String IndustryType='CHURCHES';
        String ZipCode='75001';
        String Channel='BDR';
        String essids='111111111111';
        String SqFootofPremise='100000+';
        String EmplyforBus='10+';
        String YearInBus='10+';
        boolean IDRFlag=false;
        String MonthlyUsage='2022-5-1:2022-05-27:11#';

        Test.setMock(HttpCalloutMock.class, new ResponseMock());
        Test.startTest();
        System.runAs(testUser)
        {
            LoadSynthesisController.insert_LoadSynthesisForDownloadUsage(essids);
            //List<QuoteWizardDealController> output= QuoteWizardDealController.submitQuoteInfoAndProceedToStep4(input1);
           // System.assertEquals(1,output[0].ipq.Number_Of_ESIIDs__c, 'Number_Of_ESIIDs should be one while validations failed');
        }
        Test.stopTest();
    }
    
         public static testMethod void insert_LoadSynthesisForDownloadUsagewithBlankEsiidsTest() 
    {
        setupData();
        
        String essids='';
        
        Test.setMock(HttpCalloutMock.class, new ResponseMock());
        Test.startTest();
        System.runAs(testUser)
        {
            LoadSynthesisController.insert_LoadSynthesisForDownloadUsage(essids);
            //List<QuoteWizardDealController> output= QuoteWizardDealController.submitQuoteInfoAndProceedToStep4(input1);
           // System.assertEquals(1,output[0].ipq.Number_Of_ESIIDs__c, 'Number_Of_ESIIDs should be one while validations failed');
        }
        Test.stopTest();
    }
    
          public static testMethod void sendDatatoBoomiTest() 
    {
        setupData();
        
        Loadsynthesis__c loadsynth= new Loadsynthesis__c();
        loadsynth.Esiids__c='111111111111';
        insert loadsynth;

        Test.setMock(HttpCalloutMock.class, new ResponseMock());
        Test.startTest();
        
        System.runAs(testUser)
        {
            try{
            LoadSynthesisController.sendDatatoBoomi(loadsynth.id);
            }
             catch(Exception e)
             {
              Boolean expectedExceptionThrown;
              if(e.getMessage().contains(' ')) {expectedExceptionThrown=true;}
              System.AssertEquals(expectedExceptionThrown, true);
             }  
        }
        Test.stopTest();
    }
    
    public static testMethod void sendDatatoBoomiForDownloadUsageTest() 
    {
        setupData();
        
        Loadsynthesis__c loadsynth= new Loadsynthesis__c();
        loadsynth.Esiids__c='111111111111';
        insert loadsynth;

        Test.setMock(HttpCalloutMock.class, new ResponseMock());
        Test.startTest();
        System.runAs(testUser)
        {
            try{
            LoadSynthesisController.sendDatatoBoomiForDownloadUsage(loadsynth.id);
            //List<QuoteWizardDealController> output= QuoteWizardDealController.submitQuoteInfoAndProceedToStep4(input1);
           // System.assertEquals(1,output[0].ipq.Number_Of_ESIIDs__c, 'Number_Of_ESIIDs should be one while validations failed');
        }
        catch(Exception e)
        {
         Boolean expectedExceptionThrown;
         if(e.getMessage().contains(' ')) {expectedExceptionThrown=true;}
         System.AssertEquals(expectedExceptionThrown, true);
        }  
        }
        Test.stopTest();
    }
    
          public static testMethod void populateLoadSynthRecommendationsSuccessTest() 
    {
        setupData();
        
        Loadsynthesis__c loadsynth= new Loadsynthesis__c();
        loadsynth.Esiids__c='111111111111';
        insert loadsynth;

        Test.setMock(HttpCalloutMock.class, new ResponseMock());
        
        LoadSynthesisOutcallService.LoadSynthesisResponse=new APIRequestResponseWrapper();
        //LoadSynthesisOutcallService.LoadSynthesisResponse.theResponse='System.HttpResponse[Status=OK, StatusCode=200]';
        LoadSynthesisOutcallService.LoadSynthesisResponse.responseData='{"LoadSynthesis_Response": {"success": "true"}}';
        LoadSynthesisOutcallService.LoadSynthesisResponse.statusCode='200';
        
        Test.startTest();
        
        System.runAs(testUser)
        {
            LoadSynthesisOutcallService.populateLoadSynthRecommendations();
            
        }
        Test.stopTest();
        
    }   
    
       public static testMethod void populateLoadSynthRecommendationsErrorTest() 
    {
        setupData();
        
        Loadsynthesis__c loadsynth= new Loadsynthesis__c();
        loadsynth.Esiids__c='111111111111';
        insert loadsynth;

        Test.setMock(HttpCalloutMock.class, new ResponseMock());
        
          
        LoadSynthesisOutcallService.LoadSynthesisResponse=new APIRequestResponseWrapper();
        //LoadSynthesisOutcallService.LoadSynthesisResponse.theResponse='System.HttpResponse[Status=OK, StatusCode=200]';
        LoadSynthesisOutcallService.LoadSynthesisResponse.responseData='{"LoadSynthesis_Response": {"error": "true","errorMessage": "Error"}}';
        LoadSynthesisOutcallService.LoadSynthesisResponse.statusCode='200';
        
        Test.startTest();
        
        System.runAs(testUser)
        {
            LoadSynthesisOutcallService.populateLoadSynthRecommendations();
            
        }
        Test.stopTest();
    }   
    
}