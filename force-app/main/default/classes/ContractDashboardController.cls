/**
 * @description Apex controller for the Contract Dashboard Lightning Web Component
 * @author AI Legal Contract Analyzer
 * @version 1.0
 */
public with sharing class ContractDashboardController {
    
    /**
     * @description Gets contract statistics for the dashboard
     * @return Map containing various contract statistics
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getContractStats() {
        try {
            Map<String, Object> stats = new Map<String, Object>();
            
            // Total contracts
            Integer totalContracts = [
                SELECT COUNT() 
                FROM Contract__c
            ];
            stats.put('totalContracts', totalContracts);
            
            // Analyzed contracts
            Integer analyzedContracts = [
                SELECT COUNT() 
                FROM Contract__c 
                WHERE Status__c = 'Analyzed'
            ];
            stats.put('analyzedContracts', analyzedContracts);
            
            // Pending contracts
            Integer pendingContracts = [
                SELECT COUNT() 
                FROM Contract__c 
                WHERE Status__c IN ('Uploaded', 'Processing', 'Under Review')
            ];
            stats.put('pendingContracts', pendingContracts);
            
            // High risk clauses
            Integer highRiskClauses = [
                SELECT COUNT() 
                FROM Clause__c 
                WHERE Risk_Level__c IN ('High', 'Critical')
            ];
            stats.put('highRiskClauses', highRiskClauses);
            
            // Average risk score
            AggregateResult avgRiskResult = [
                SELECT AVG(Overall_Risk_Score__c) avgRisk
                FROM Contract__c
                WHERE Overall_Risk_Score__c != NULL
            ];
            stats.put('averageRiskScore', avgRiskResult.get('avgRisk'));

            // Recent Contracts (limit 5)
            List<Contract__c> recentContracts = [
                SELECT Id, Name, Title__c, Contract_Type__c, Status__c, Overall_Risk_Score__c, CreatedDate
                FROM Contract__c
                ORDER BY CreatedDate DESC
                LIMIT 5
            ];
            stats.put('recentContracts', recentContracts);

            // Risk Distribution (example data)
            List<Map<String, Object>> riskDistribution = new List<Map<String, Object>>();
            riskDistribution.add(new Map<String, Object>{'label' => 'Low Risk', 'value' => 40});
            riskDistribution.add(new Map<String, Object>{'label' => 'Medium Risk', 'value' => 35});
            riskDistribution.add(new Map<String, Object>{'label' => 'High Risk', 'value' => 20});
            riskDistribution.add(new Map<String, Object>{'label' => 'Critical Risk', 'value' => 5});
            stats.put('riskDistribution', riskDistribution);
            
            return stats;
        } catch (Exception e) {
            System.debug('Error in getContractStats: ' + e.getMessage());
            throw new AuraHandledException('Error fetching contract statistics: ' + e.getMessage());
        }
    }

    /**
     * @description Gets a list of contracts for display in the dashboard.
     * @param searchTerm Optional search term to filter contracts by title.
     * @return List of Contract__c records.
     */
    @AuraEnabled(cacheable=true)
    public static List<Contract__c> getContracts(String searchTerm) {
        String query = 'SELECT Id, Name, Title__c, Contract_Type__c, Status__c, Overall_Risk_Score__c, CreatedDate FROM Contract__c';
        if (String.isNotBlank(searchTerm)) {
            query += ' WHERE Title__c LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
        }
        query += ' ORDER BY CreatedDate DESC LIMIT 10'; // Limit for dashboard display
        return Database.query(query);
    }

    /**
     * @description Gets a list of clauses for a specific contract.
     * @param contractId The ID of the parent contract.
     * @return List of Clause__c records.
     */
    @AuraEnabled(cacheable=true)
    public static List<Clause__c> getClausesForContract(Id contractId) {
        return [
            SELECT Id, Name, Title__c, Clause_Type__c, Original_Text__c, Risk_Level__c, Risk_Score__c, Status__c
            FROM Clause__c
            WHERE Contract__c = :contractId
            ORDER BY CreatedDate DESC
        ];
    }

    /**
     * @description Updates the status of a contract.
     * @param contractId The ID of the contract to update.
     * @param newStatus The new status value.
     */
    @AuraEnabled
    public static void updateContractStatus(Id contractId, String newStatus) {
        Contract__c contract = [SELECT Id, Status__c FROM Contract__c WHERE Id = :contractId];
        contract.Status__c = newStatus;
        update contract;
    }

    /**
     * @description Updates the risk level of a clause.
     * @param clauseId The ID of the clause to update.
     * @param newRiskLevel The new risk level value.
     */
    @AuraEnabled
    public static void updateClauseRiskLevel(Id clauseId, String newRiskLevel) {
        Clause__c clause = [SELECT Id, Risk_Level__c FROM Clause__c WHERE Id = :clauseId];
        clause.Risk_Level__c = newRiskLevel;
        update clause;
    }
}