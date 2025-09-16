/**
 * ADDED: Apex subscriber for ClauseStatusEvent__e platform event.
 * Logs events to debug for verification.
 */
public with sharing class ClauseStatusEventSubscriber {
    @AuraEnabled
    public static void subscribe(List<ClauseStatusEvent__e> events){
        for (ClauseStatusEvent__e e : events) {
            System.debug('ClauseStatusEvent__e received: ' + e);
        }
    }
}


