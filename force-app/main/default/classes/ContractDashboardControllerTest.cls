/**
 * @description Test class for ContractDashboardController
 * @author AI Legal Contract Analyzer
 * @version 1.0
 */
@isTest
public class ContractDashboardControllerTest {
    
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
        
        // Create test contracts
        List<Contract__c> contracts = new List<Contract__c>();
        for (Integer i = 0; i < 5; i++) {
            contracts.add(new Contract__c(
                Title__c = 'Test Contract ' + i,
                Contract_Type__c = 'Software License',
                Status__c = i < 2 ? 'Analyzed' : 'Under Review',
                Overall_Risk_Score__c = 0.5 + (i * 0.1),
                OwnerId = testUser.Id
            ));
        }
        insert contracts;
        
        // Create test clauses
        List<Clause__c> clauses = new List<Clause__c>();
        for (Contract__c contract : contracts) {
            clauses.add(new Clause__c(
                Title__c = 'Test Clause for ' + contract.Title__c,
                Clause_Type__c = 'Liability',
                Risk_Level__c = 'High',
                Status__c = 'Pending',
                Contract__c = contract.Id
            ));
        }
        insert clauses;
    }
    
    @isTest
    static void testGetContractStats() {
        Test.startTest();
        
        // Test getting contract stats
        Map<String, Object> stats = ContractDashboardController.getContractStats();
        
        Test.stopTest();
        
        // Verify results
        System.assert(stats != null, 'Stats should not be null');
        System.assert(stats.get('totalContracts') != null, 'Total contracts should be present');
        System.assert(stats.get('analyzedContracts') != null, 'Analyzed contracts should be present');
        System.assert(stats.get('pendingContracts') != null, 'Pending contracts should be present');
        System.assert(stats.get('highRiskClauses') != null, 'High risk clauses should be present');
        System.assert(stats.get('averageRiskScore') != null, 'Average risk score should be present');
        System.assert(stats.get('recentContracts') != null, 'Recent contracts should be present');
        System.assert(stats.get('riskDistribution') != null, 'Risk distribution should be present');
    }
    
    @isTest
    static void testGetContracts() {
        Test.startTest();
        
        // Test getting contracts without search term
        List<Contract__c> contracts = ContractDashboardController.getContracts(null);
        
        Test.stopTest();
        
        // Verify results
        System.assert(contracts != null, 'Contracts should not be null');
        System.assert(contracts.size() > 0, 'Should return contracts');
    }
    
    @isTest
    static void testGetContractsWithSearchTerm() {
        Test.startTest();
        
        // Test getting contracts with search term
        List<Contract__c> contracts = ContractDashboardController.getContracts('Test Contract 1');
        
        Test.stopTest();
        
        // Verify results
        System.assert(contracts != null, 'Contracts should not be null');
        System.assert(contracts.size() > 0, 'Should return matching contracts');
    }
    
    @isTest
    static void testGetClausesForContract() {
        // Get test contract
        Contract__c testContract = [SELECT Id FROM Contract__c LIMIT 1];
        
        Test.startTest();
        
        // Test getting clauses for contract
        List<Clause__c> clauses = ContractDashboardController.getClausesForContract(testContract.Id);
        
        Test.stopTest();
        
        // Verify results
        System.assert(clauses != null, 'Clauses should not be null');
        System.assert(clauses.size() > 0, 'Should return clauses for the contract');
    }
    
    @isTest
    static void testUpdateContractStatus() {
        // Get test contract
        Contract__c testContract = [SELECT Id, Status__c FROM Contract__c LIMIT 1];
        String originalStatus = testContract.Status__c;
        
        Test.startTest();
        
        // Test updating contract status
        ContractDashboardController.updateContractStatus(testContract.Id, 'Approved');
        
        Test.stopTest();
        
        // Verify status was updated
        Contract__c updatedContract = [SELECT Status__c FROM Contract__c WHERE Id = :testContract.Id];
        System.assertEquals('Approved', updatedContract.Status__c, 'Status should be updated');
    }
    
    @isTest
    static void testUpdateClauseRiskLevel() {
        // Get test clause
        Clause__c testClause = [SELECT Id, Risk_Level__c FROM Clause__c LIMIT 1];
        String originalRiskLevel = testClause.Risk_Level__c;
        
        Test.startTest();
        
        // Test updating clause risk level
        ContractDashboardController.updateClauseRiskLevel(testClause.Id, 'Low');
        
        Test.stopTest();
        
        // Verify risk level was updated
        Clause__c updatedClause = [SELECT Risk_Level__c FROM Clause__c WHERE Id = :testClause.Id];
        System.assertEquals('Low', updatedClause.Risk_Level__c, 'Risk level should be updated');
    }
}
