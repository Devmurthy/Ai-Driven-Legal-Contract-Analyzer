/**
 * @description Trigger to handle clause status changes and send notifications
 * @author AI Legal Contract Analyzer
 * @version 1.0
 */
trigger ClauseStatusTrigger on Clause__c (after update) {
    
    // List to store record IDs that need notification
    List<Id> recordsToNotify = new List<Id>();
    
    // Check each updated record for status changes
    for (Clause__c newRecord : Trigger.new) {
        Clause__c oldRecord = Trigger.oldMap.get(newRecord.Id);
        
        // Check if status changed to Approved or Rejected
        if (oldRecord.Status__c != newRecord.Status__c && 
            (newRecord.Status__c == 'Approved' || newRecord.Status__c == 'Rejected')) {
            recordsToNotify.add(newRecord.Id);
        }
    }
    
    // Send notifications for approved/rejected clauses
    if (!recordsToNotify.isEmpty()) {
        StatusNotificationService.sendClauseStatusNotification(recordsToNotify, 'Status Changed');
    }
}
