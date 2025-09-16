/**
 * @description Test class for AINegotiationService
 * @author AI Legal Contract Analyzer
 * @version 1.0
 */
@isTest
public class AINegotiationServiceTest {
    
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
        
        // Create test contract
        Contract__c testContract = new Contract__c(
            Title__c = 'Test Contract',
            Contract_Type__c = 'Software License',
            Status__c = 'Under Review',
            OwnerId = testUser.Id
        );
        insert testContract;
        
        // Create test clause
        Clause__c testClause = new Clause__c(
            Title__c = 'Test Clause',
            Clause_Type__c = 'Liability',
            Risk_Level__c = 'Medium',
            Status__c = 'Pending',
            Original_Text__c = 'Company shall not be liable for any damages arising from the use of this software.',
            Contract__c = testContract.Id
        );
        insert testClause;
    }
    
    @isTest
    static void testGenerateNegotiationSuggestion() {
        // Get test data
        Clause__c testClause = [SELECT Id FROM Clause__c LIMIT 1];
        
        Test.startTest();
        
        // Test generating negotiation suggestion
        Map<String, Object> result = AINegotiationService.generateNegotiationSuggestion(
            testClause.Id, 
            'Buyer', 
            'Collaborative'
        );
        
        Test.stopTest();
        
        // Verify results
        System.assert((Boolean)result.get('success'), 'Suggestion generation should succeed');
        System.assert(result.get('suggestion') != null, 'Suggestion should be created');
        System.assert(result.get('suggestedText') != null, 'Suggested text should be present');
        System.assert(result.get('explanation') != null, 'Explanation should be present');
        
        // Verify negotiation suggestion record was created
        List<NegotiationSuggestion__c> suggestions = [
            SELECT Id, Party_Goal__c, Negotiation_Tone__c, Status__c 
            FROM NegotiationSuggestion__c 
            WHERE Clause__c = :testClause.Id
        ];
        System.assertEquals(1, suggestions.size(), 'One suggestion should be created');
        System.assertEquals('Buyer', suggestions[0].Party_Goal__c, 'Party goal should match');
        System.assertEquals('Collaborative', suggestions[0].Negotiation_Tone__c, 'Negotiation tone should match');
        System.assertEquals('Generated', suggestions[0].Status__c, 'Status should be Generated');
    }
    
    @isTest
    static void testGenerateNegotiationSuggestionWithInvalidId() {
        Test.startTest();
        
        // Test with invalid ID
        Map<String, Object> result = AINegotiationService.generateNegotiationSuggestion(
            null, 
            'Buyer', 
            'Collaborative'
        );
        
        Test.stopTest();
        
        // Verify failure
        System.assert(!(Boolean)result.get('success'), 'Suggestion generation should fail');
    }
    
    @isTest
    static void testGenerateNegotiationSuggestionWithDifferentParameters() {
        // Get test data
        Clause__c testClause = [SELECT Id FROM Clause__c LIMIT 1];
        
        Test.startTest();
        
        // Test with different parameters
        Map<String, Object> result = AINegotiationService.generateNegotiationSuggestion(
            testClause.Id, 
            'Seller', 
            'Aggressive'
        );
        
        Test.stopTest();
        
        // Verify results
        System.assert((Boolean)result.get('success'), 'Suggestion generation should succeed');
        
        // Verify negotiation suggestion record was created with correct parameters
        List<NegotiationSuggestion__c> suggestions = [
            SELECT Id, Party_Goal__c, Negotiation_Tone__c 
            FROM NegotiationSuggestion__c 
            WHERE Clause__c = :testClause.Id
        ];
        System.assertEquals(1, suggestions.size(), 'One suggestion should be created');
        System.assertEquals('Seller', suggestions[0].Party_Goal__c, 'Party goal should match');
        System.assertEquals('Aggressive', suggestions[0].Negotiation_Tone__c, 'Negotiation tone should match');
    }
}
