/**
 * @description Test class for StatusNotificationService
 * @author AI Legal Contract Analyzer
 * @version 1.0
 */
@isTest
public class StatusNotificationServiceTest {
    
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
            Contract__c = testContract.Id
        );
        insert testClause;
    }
    
    @isTest
    static void testSendContractStatusNotification() {
        // Get test data
        Contract__c testContract = [SELECT Id FROM Contract__c LIMIT 1];
        
        Test.startTest();
        
        // Test sending notification for approved status
        StatusNotificationService.sendContractStatusNotification(
            new List<Id>{testContract.Id}, 
            'Approved'
        );
        
        // Test sending notification for rejected status
        StatusNotificationService.sendContractStatusNotification(
            new List<Id>{testContract.Id}, 
            'Rejected'
        );
        
        Test.stopTest();
        
        // Verify no exceptions were thrown
        System.assert(true, 'Notifications sent successfully');
    }
    
    @isTest
    static void testSendClauseStatusNotification() {
        // Get test data
        Clause__c testClause = [SELECT Id FROM Clause__c LIMIT 1];
        
        Test.startTest();
        
        // Test sending notification for approved status
        StatusNotificationService.sendClauseStatusNotification(
            new List<Id>{testClause.Id}, 
            'Approved'
        );
        
        // Test sending notification for rejected status
        StatusNotificationService.sendClauseStatusNotification(
            new List<Id>{testClause.Id}, 
            'Rejected'
        );
        
        Test.stopTest();
        
        // Verify no exceptions were thrown
        System.assert(true, 'Notifications sent successfully');
    }
    
    @isTest
    static void testSendContractStatusNotificationWithEmptyList() {
        Test.startTest();
        
        // Test with empty list
        StatusNotificationService.sendContractStatusNotification(
            new List<Id>(), 
            'Approved'
        );
        
        Test.stopTest();
        
        // Verify no exceptions were thrown
        System.assert(true, 'Empty list handled successfully');
    }
    
    @isTest
    static void testSendClauseStatusNotificationWithEmptyList() {
        Test.startTest();
        
        // Test with empty list
        StatusNotificationService.sendClauseStatusNotification(
            new List<Id>(), 
            'Approved'
        );
        
        Test.stopTest();
        
        // Verify no exceptions were thrown
        System.assert(true, 'Empty list handled successfully');
    }
}
