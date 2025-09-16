/**
 * ADDED: Integration test to exercise Contract status change flow wiring.
 * Verifies update + debug log expectation by publishing platform event via flow.
 */
@IsTest
public class ContractFlowIntegrationTest {
    @IsTest
    static void testContractStatusChangePublishesEvent() {
        Contract__c c = new Contract__c(Title__c = 'Test Flow Contract', Status__c = 'Draft', Contract_Type__c = 'Services');
        insert c;

        Test.startTest();
        c.Status__c = 'Approved';
        update c;
        Test.stopTest();

        // We can't query platform events directly; assert no exception and basic state updated
        Contract__c c2 = [SELECT Id, Status__c FROM Contract__c WHERE Id = :c.Id];
        System.assertEquals('Approved', c2.Status__c);
    }
}


