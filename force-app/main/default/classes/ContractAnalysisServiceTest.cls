/**
 * @description Test class for ContractAnalysisService
 * @author AI Legal Contract Analyzer
 * @version 1.0
 */
@isTest
public class ContractAnalysisServiceTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test user
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser' + System.currentTimeMillis() + '@example.com.test',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id
        );
        insert testUser;
        
        // Create test contract with extracted text
        Contract__c testContract = new Contract__c(
            Title__c = 'Test Contract',
            Contract_Type__c = 'Software License',
            Status__c = 'Uploaded',
            Extracted_Text__c = 'PAYMENT: Payment shall be made within 30 days. LIABILITY: Company shall not be liable for damages. TERMINATION: Either party may terminate with 30 days notice.',
            OwnerId = testUser.Id
        );
        insert testContract;
    }
    
    @isTest
    static void testAnalyzeContract() {
        // Get test data
        Contract__c testContract = [SELECT Id FROM Contract__c LIMIT 1];
        
        Test.startTest();
        
        // Test contract analysis
        Map<String, Object> result = ContractAnalysisService.analyzeContract(testContract.Id);
        
        Test.stopTest();
        
        // Verify results
        System.assert((Boolean)result.get('success'), 'Analysis should succeed');
        System.assert(result.get('clauses') != null, 'Clauses should be extracted');
        System.assert(result.get('overallRiskScore') != null, 'Risk score should be calculated');
        
        // Verify contract was updated
        Contract__c updatedContract = [SELECT Status__c, Overall_Risk_Score__c, Total_Clauses__c FROM Contract__c WHERE Id = :testContract.Id];
        System.assertEquals('Analyzed', updatedContract.Status__c, 'Contract status should be updated');
        System.assert(updatedContract.Overall_Risk_Score__c != null, 'Risk score should be set');
        System.assert(updatedContract.Total_Clauses__c > 0, 'Total clauses should be set');
    }
    
    @isTest
    static void testAnalyzeContractWithNoText() {
        // Create contract without extracted text
        Contract__c testContract = new Contract__c(
            Title__c = 'Test Contract No Text',
            Contract_Type__c = 'Software License',
            Status__c = 'Uploaded'
        );
        insert testContract;
        
        Test.startTest();
        
        // Test contract analysis
        Map<String, Object> result = ContractAnalysisService.analyzeContract(testContract.Id);
        
        Test.stopTest();
        
        // Verify failure
        System.assert(!(Boolean)result.get('success'), 'Analysis should fail');
        System.assert(result.get('error') != null, 'Error message should be present');
    }
    
    @isTest
    static void testAnalyzeContractWithInvalidId() {
        Test.startTest();
        
        // Test with invalid ID
        Map<String, Object> result = ContractAnalysisService.analyzeContract(null);
        
        Test.stopTest();
        
        // Verify failure
        System.assert(!(Boolean)result.get('success'), 'Analysis should fail');
    }
}
