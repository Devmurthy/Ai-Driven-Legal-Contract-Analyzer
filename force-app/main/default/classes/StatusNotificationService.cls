/**
 * @description Service class for sending status change notifications
 * @author AI Legal Contract Analyzer
 * @version 1.0
 */
public with sharing class StatusNotificationService {
    
    /**
     * @description Send notification when contract status changes to Approved or Rejected
     * @param contractIds List of contract IDs that changed status
     * @param newStatus The new status value
     */
    public static void sendContractStatusNotification(List<Id> contractIds, String newStatus) {
        try {
            // Query contracts
            List<Contract__c> contracts = [
                SELECT Id, Name, Title__c, Status__c, Contract_Type__c, OwnerId
                FROM Contract__c 
                WHERE Id IN :contractIds
            ];
            
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            
            for (Contract__c contract : contracts) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                // Set recipient - get user email from OwnerId
                User owner = [SELECT Email FROM User WHERE Id = :contract.OwnerId LIMIT 1];
                email.setToAddresses(new String[]{owner.Email});
                
                // Set subject
                email.setSubject('Contract Status Update: ' + contract.Name);
                
                // Set email body
                String emailBody = createEmailBody(contract, newStatus, 'Contract');
                email.setPlainTextBody(emailBody);
                
                emails.add(email);
            }
            
            // Send emails
            if (!emails.isEmpty()) {
                Messaging.sendEmail(emails);
                System.debug('Sent ' + emails.size() + ' contract status notifications');
            }
            
        } catch (Exception e) {
            System.debug('Error sending contract status notification: ' + e.getMessage());
        }
    }
    
    /**
     * @description Send notification when clause status changes to Approved or Rejected
     * @param clauseIds List of clause IDs that changed status
     * @param newStatus The new status value
     */
    public static void sendClauseStatusNotification(List<Id> clauseIds, String newStatus) {
        try {
            // Query clauses
            List<Clause__c> clauses = [
                SELECT Id, Name, Title__c, Status__c, Clause_Type__c,
                       Contract__r.Name, Contract__r.Title__c, Contract__r.OwnerId
                FROM Clause__c 
                WHERE Id IN :clauseIds
            ];
            
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            
            for (Clause__c clause : clauses) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                // Set recipient - get user email from Contract OwnerId
                User owner = [SELECT Email FROM User WHERE Id = :clause.Contract__r.OwnerId LIMIT 1];
                email.setToAddresses(new String[]{owner.Email});
                
                // Set subject
                email.setSubject('Clause Status Update: ' + clause.Name);
                
                // Set email body
                String emailBody = createEmailBody(clause, newStatus, 'Clause');
                email.setPlainTextBody(emailBody);
                
                emails.add(email);
            }
            
            // Send emails
            if (!emails.isEmpty()) {
                Messaging.sendEmail(emails);
                System.debug('Sent ' + emails.size() + ' clause status notifications');
            }
            
        } catch (Exception e) {
            System.debug('Error sending clause status notification: ' + e.getMessage());
        }
    }
    
    /**
     * @description Create email body for status notifications
     * @param record The record (Contract or Clause)
     * @param newStatus The new status
     * @param recordType The type of record (Contract or Clause)
     * @return String The formatted email body
     */
    private static String createEmailBody(SObject record, String newStatus, String recordType) {
        String body = '';
        
        if (recordType == 'Contract') {
            Contract__c contract = (Contract__c) record;
            body = 'Dear User,\n\n';
            body += 'The status of your contract has been updated:\n\n';
            body += 'Contract Number: ' + contract.Name + '\n';
            body += 'Contract Title: ' + contract.Title__c + '\n';
            body += 'Contract Type: ' + contract.Contract_Type__c + '\n';
            body += 'New Status: ' + newStatus + '\n';
            body += 'Updated By: ' + UserInfo.getName() + '\n';
            body += 'Updated Date: ' + DateTime.now().format('MM/dd/yyyy HH:mm:ss') + '\n\n';
            
            if (newStatus == 'Approved') {
                body += 'Congratulations! Your contract has been approved and is ready for execution.\n\n';
            } else if (newStatus == 'Rejected') {
                body += 'Please review the contract as it has been rejected. You may need to make revisions.\n\n';
            }
            
        } else if (recordType == 'Clause') {
            Clause__c clause = (Clause__c) record;
            body = 'Dear User,\n\n';
            body += 'The status of your contract clause has been updated:\n\n';
            body += 'Clause Number: ' + clause.Name + '\n';
            body += 'Clause Title: ' + clause.Title__c + '\n';
            body += 'Clause Type: ' + clause.Clause_Type__c + '\n';
            body += 'Parent Contract: ' + clause.Contract__r.Name + ' - ' + clause.Contract__r.Title__c + '\n';
            body += 'New Status: ' + newStatus + '\n';
            body += 'Updated By: ' + UserInfo.getName() + '\n';
            body += 'Updated Date: ' + DateTime.now().format('MM/dd/yyyy HH:mm:ss') + '\n\n';
            
            if (newStatus == 'Approved') {
                body += 'Great news! This clause has been approved and meets all requirements.\n\n';
            } else if (newStatus == 'Rejected') {
                body += 'This clause has been rejected and requires revision before approval.\n\n';
            }
        }
        
        body += 'Please log into Salesforce to review the updated record.\n\n';
        body += 'Best regards,\n';
        body += 'AI Legal Contract Analyzer System\n\n';
        body += 'This is an automated notification. Please do not reply to this email.';
        
        return body;
    }
}