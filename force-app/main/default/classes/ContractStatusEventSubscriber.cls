/**
 * ADDED: Apex subscriber for ContractStatusEvent__e platform event.
 * Logs events to debug for verification.
 */
public with sharing class ContractStatusEventSubscriber {
    @AuraEnabled
    public static void subscribe(List<ContractStatusEvent__e> events){
        for (ContractStatusEvent__e e : events) {
            System.debug('ContractStatusEvent__e received: ' + e);
        }
    }
}


