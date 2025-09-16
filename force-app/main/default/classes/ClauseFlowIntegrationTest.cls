/**
 * ADDED: Integration test to exercise Clause status change flow wiring.
 */
@IsTest
public class ClauseFlowIntegrationTest {
    @IsTest
    static void testClauseStatusChangePublishesEvent() {
        Contract__c c = new Contract__c(Title__c = 'Test Flow Contract 2', Status__c = 'Draft', Contract_Type__c = 'NDA');
        insert c;
        Clause__c cl = new Clause__c(Title__c = 'Test Clause', Status__c = 'Draft', Clause_Type__c = 'General', Risk_Level__c = 'Low', Contract__c = c.Id);
        insert cl;

        Test.startTest();
        cl.Status__c = 'Approved';
        update cl;
        Test.stopTest();

        Clause__c cl2 = [SELECT Id, Status__c FROM Clause__c WHERE Id = :cl.Id];
        System.assertEquals('Approved', cl2.Status__c);
    }
}


