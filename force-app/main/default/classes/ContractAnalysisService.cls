/**
 * @description Service class for contract analysis and clause extraction
 * @author AI Legal Contract Analyzer
 * @version 1.0
 */
public with sharing class ContractAnalysisService {
    
    /**
     * @description Analyzes a contract and extracts clauses
     * @param contractId The ID of the contract to analyze
     * @return Map containing analysis results
     */
    public static Map<String, Object> analyzeContract(Id contractId) {
        Map<String, Object> result = new Map<String, Object>();
        
        try {
            // Get contract details
            Contract__c contract = [
                SELECT Id, Name, Title__c, Extracted_Text__c, Status__c
                FROM Contract__c 
                WHERE Id = :contractId
            ];
            
            if (String.isBlank(contract.Extracted_Text__c)) {
                result.put('success', false);
                result.put('error', 'No extracted text found for contract');
                return result;
            }
            
            // Extract clauses using simple pattern matching
            List<Map<String, Object>> clauses = extractClauses(contract.Extracted_Text__c, contractId);
            
            // Calculate overall risk score
            Decimal overallRiskScore = calculateOverallRiskScore(clauses);
            
            // Update contract with analysis results
            contract.Overall_Risk_Score__c = overallRiskScore;
            contract.Total_Clauses__c = clauses.size();
            contract.Status__c = 'Analyzed';
            contract.Analyzed_Date__c = DateTime.now();
            
            update contract;
            
            result.put('success', true);
            result.put('clauses', clauses);
            result.put('overallRiskScore', overallRiskScore);
            result.put('totalClauses', clauses.size());
            
        } catch (Exception e) {
            System.debug('Error in analyzeContract: ' + e.getMessage());
            result.put('success', false);
            result.put('error', e.getMessage());
        }
        
        return result;
    }
    
    /**
     * @description Extracts clauses from contract text using pattern matching
     * @param contractText The text to analyze
     * @param contractId The ID of the parent contract
     * @return List of clause maps
     */
    private static List<Map<String, Object>> extractClauses(String contractText, Id contractId) {
        List<Map<String, Object>> clauses = new List<Map<String, Object>>();
        
        // Simple clause extraction using common patterns
        List<String> clausePatterns = new List<String>{
            'PAYMENT.*?[\\n\\r]',
            'LIABILITY.*?[\\n\\r]',
            'TERMINATION.*?[\\n\\r]',
            'CONFIDENTIALITY.*?[\\n\\r]',
            'INTELLECTUAL PROPERTY.*?[\\n\\r]'
        };
        
        List<String> clauseTypes = new List<String>{
            'Payment',
            'Liability', 
            'Termination',
            'Confidentiality',
            'Intellectual Property'
        };
        
        for (Integer i = 0; i < clausePatterns.size(); i++) {
            Pattern p = Pattern.compile(clausePatterns[i]);
            Matcher m = p.matcher(contractText);
            
            if (m.find()) {
                String clauseText = m.group(0);
                Map<String, Object> clause = new Map<String, Object>();
                clause.put('title', clauseTypes[i] + ' Clause');
                clause.put('clauseType', clauseTypes[i]);
                clause.put('originalText', clauseText);
                clause.put('riskLevel', calculateRiskLevel(clauseText));
                clause.put('riskScore', calculateRiskScore(clauseText));
                clause.put('startPosition', m.start());
                clause.put('endPosition', m.end());
                
                // Create clause record
                createClauseRecord(clause, contractId);
                
                clauses.add(clause);
            }
        }
        
        return clauses;
    }
    
    /**
     * @description Creates a clause record in the database
     * @param clauseData Map containing clause information
     * @param contractId The ID of the parent contract
     */
    private static void createClauseRecord(Map<String, Object> clauseData, Id contractId) {
        Clause__c clause = new Clause__c();
        clause.Contract__c = contractId;
        clause.Title__c = (String)clauseData.get('title');
        clause.Clause_Type__c = (String)clauseData.get('clauseType');
        clause.Original_Text__c = (String)clauseData.get('originalText');
        clause.Risk_Level__c = (String)clauseData.get('riskLevel');
        clause.Risk_Score__c = (Decimal)clauseData.get('riskScore');
        clause.Start_Position__c = (Integer)clauseData.get('startPosition');
        clause.End_Position__c = (Integer)clauseData.get('endPosition');
        clause.Status__c = 'Pending';
        
        insert clause;
    }
    
    /**
     * @description Calculates risk level based on clause content
     * @param clauseText The clause text to analyze
     * @return Risk level string
     */
    private static String calculateRiskLevel(String clauseText) {
        String lowerText = clauseText.toLowerCase();
        
        if (lowerText.contains('penalty') || lowerText.contains('damages') || lowerText.contains('liability')) {
            return 'High';
        } else if (lowerText.contains('termination') || lowerText.contains('breach')) {
            return 'Medium';
        } else {
            return 'Low';
        }
    }
    
    /**
     * @description Calculates risk score based on clause content
     * @param clauseText The clause text to analyze
     * @return Risk score decimal
     */
    private static Decimal calculateRiskScore(String clauseText) {
        String lowerText = clauseText.toLowerCase();
        Decimal score = 0.0;
        
        if (lowerText.contains('penalty')) score += 0.3;
        if (lowerText.contains('damages')) score += 0.4;
        if (lowerText.contains('liability')) score += 0.3;
        if (lowerText.contains('termination')) score += 0.2;
        if (lowerText.contains('breach')) score += 0.2;
        
        return Math.min(score, 1.0);
    }
    
    /**
     * @description Calculates overall risk score for all clauses
     * @param clauses List of clause data
     * @return Overall risk score
     */
    private static Decimal calculateOverallRiskScore(List<Map<String, Object>> clauses) {
        if (clauses.isEmpty()) {
            return 0.0;
        }
        
        Decimal totalScore = 0.0;
        for (Map<String, Object> clause : clauses) {
            totalScore += (Decimal)clause.get('riskScore');
        }
        
        return totalScore / clauses.size();
    }
}