/**
 * @description Trigger to handle contract status changes and send notifications
 * @author AI Legal Contract Analyzer
 * @version 1.0
 */
trigger ContractStatusTrigger on Contract__c (after update) {
    
    // List to store record IDs that need notification
    List<Id> recordsToNotify = new List<Id>();
    
    // Check each updated record for status changes
    for (Contract__c newRecord : Trigger.new) {
        Contract__c oldRecord = Trigger.oldMap.get(newRecord.Id);
        
        // Check if status changed to Approved or Rejected
        if (oldRecord.Status__c != newRecord.Status__c && 
            (newRecord.Status__c == 'Approved' || newRecord.Status__c == 'Rejected')) {
            recordsToNotify.add(newRecord.Id);
        }
    }
    
    // Send notifications for approved/rejected contracts
    if (!recordsToNotify.isEmpty()) {
        StatusNotificationService.sendContractStatusNotification(recordsToNotify, 'Status Changed');
    }
}
