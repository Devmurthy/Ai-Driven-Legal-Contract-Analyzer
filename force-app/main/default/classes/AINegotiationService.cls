/**
 * @description Service class for AI-powered negotiation suggestions
 * @author AI Legal Contract Analyzer
 * @version 1.0
 */
public with sharing class AINegotiationService {
    
    /**
     * @description Generates negotiation suggestions for a clause
     * @param clauseId The ID of the clause to analyze
     * @param partyGoal The goal of the negotiating party
     * @param negotiationTone The tone of negotiation
     * @return Map containing suggestions
     */
    public static Map<String, Object> generateNegotiationSuggestion(Id clauseId, String partyGoal, String negotiationTone) {
        Map<String, Object> result = new Map<String, Object>();
        
        try {
            // Get clause details
            Clause__c clause = [
                SELECT Id, Name, Title__c, Clause_Type__c, Original_Text__c, Risk_Level__c, Risk_Score__c,
                       Contract__r.Name, Contract__r.Title__c
                FROM Clause__c 
                WHERE Id = :clauseId
            ];
            
            // Generate AI-powered suggestions
            Map<String, Object> suggestion = createNegotiationSuggestion(clause, partyGoal, negotiationTone);
            
            // Create negotiation suggestion record
            NegotiationSuggestion__c ns = new NegotiationSuggestion__c();
            ns.Clause__c = clauseId;
            ns.Party_Goal__c = partyGoal;
            ns.Negotiation_Tone__c = negotiationTone;
            ns.Suggested_Text__c = (String)suggestion.get('suggestedText');
            ns.Explanation__c = (String)suggestion.get('explanation');
            ns.Risk_Impact__c = (String)suggestion.get('riskImpact');
            ns.Risk_Change__c = (Decimal)suggestion.get('riskChange');
            ns.Confidence_Score__c = (Decimal)suggestion.get('confidenceScore');
            ns.Status__c = 'Generated';
            ns.AI_Model__c = 'Salesforce AI';
            
            insert ns;
            
            result.put('success', true);
            result.put('suggestion', ns);
            result.put('suggestedText', suggestion.get('suggestedText'));
            result.put('explanation', suggestion.get('explanation'));
            
        } catch (Exception e) {
            System.debug('Error in generateNegotiationSuggestion: ' + e.getMessage());
            result.put('success', false);
            result.put('error', e.getMessage());
        }
        
        return result;
    }
    
    /**
     * @description Creates negotiation suggestion based on clause analysis
     * @param clause The clause to analyze
     * @param partyGoal The goal of the negotiating party
     * @param negotiationTone The tone of negotiation
     * @return Map containing suggestion details
     */
    private static Map<String, Object> createNegotiationSuggestion(Clause__c clause, String partyGoal, String negotiationTone) {
        Map<String, Object> suggestion = new Map<String, Object>();
        
        String originalText = clause.Original_Text__c;
        String clauseType = clause.Clause_Type__c;
        String riskLevel = clause.Risk_Level__c;
        
        // Generate suggested text based on party goal and tone
        String suggestedText = generateSuggestedText(originalText, clauseType, partyGoal, negotiationTone);
        
        // Generate explanation
        String explanation = generateExplanation(clauseType, partyGoal, negotiationTone);
        
        // Calculate risk impact
        String riskImpact = calculateRiskImpact(clauseType, partyGoal);
        Decimal riskChange = calculateRiskChange(clauseType, partyGoal, riskLevel);
        
        // Calculate confidence score
        Decimal confidenceScore = calculateConfidenceScore(clauseType, partyGoal, negotiationTone);
        
        suggestion.put('suggestedText', suggestedText);
        suggestion.put('explanation', explanation);
        suggestion.put('riskImpact', riskImpact);
        suggestion.put('riskChange', riskChange);
        suggestion.put('confidenceScore', confidenceScore);
        
        return suggestion;
    }
    
    /**
     * @description Generates suggested text based on analysis
     * @param originalText The original clause text
     * @param clauseType The type of clause
     * @param partyGoal The goal of the negotiating party
     * @param negotiationTone The tone of negotiation
     * @return Suggested text
     */
    private static String generateSuggestedText(String originalText, String clauseType, String partyGoal, String negotiationTone) {
        // Simple text generation based on rules
        if (clauseType == 'Payment' && partyGoal == 'Buyer') {
            return 'Payment terms should be modified to extend the payment period to 60 days and include early payment discounts.';
        } else if (clauseType == 'Liability' && partyGoal == 'Seller') {
            return 'Liability should be limited to the contract value and exclude consequential damages.';
        } else if (clauseType == 'Termination' && partyGoal == 'Buyer') {
            return 'Termination clause should allow for 30 days notice and include termination for convenience.';
        } else {
            return 'Consider revising this clause to better align with your negotiation objectives.';
        }
    }
    
    /**
     * @description Generates explanation for the suggestion
     * @param clauseType The type of clause
     * @param partyGoal The goal of the negotiating party
     * @param negotiationTone The tone of negotiation
     * @return Explanation text
     */
    private static String generateExplanation(String clauseType, String partyGoal, String negotiationTone) {
        return 'This suggestion is based on industry best practices for ' + clauseType.toLowerCase() + 
               ' clauses when negotiating from a ' + partyGoal.toLowerCase() + ' perspective using a ' + 
               negotiationTone.toLowerCase() + ' approach.';
    }
    
    /**
     * @description Calculates risk impact of the suggestion
     * @param clauseType The type of clause
     * @param partyGoal The goal of the negotiating party
     * @return Risk impact string
     */
    private static String calculateRiskImpact(String clauseType, String partyGoal) {
        if (clauseType == 'Liability' && partyGoal == 'Seller') {
            return 'Decreased';
        } else if (clauseType == 'Payment' && partyGoal == 'Buyer') {
            return 'Unchanged';
        } else {
            return 'Increased';
        }
    }
    
    /**
     * @description Calculates risk change score
     * @param clauseType The type of clause
     * @param partyGoal The goal of the negotiating party
     * @param currentRiskLevel The current risk level
     * @return Risk change score
     */
    private static Decimal calculateRiskChange(String clauseType, String partyGoal, String currentRiskLevel) {
        if (clauseType == 'Liability' && partyGoal == 'Seller') {
            return -0.2;
        } else if (clauseType == 'Payment' && partyGoal == 'Buyer') {
            return 0.0;
        } else {
            return 0.1;
        }
    }
    
    /**
     * @description Calculates confidence score for the suggestion
     * @param clauseType The type of clause
     * @param partyGoal The goal of the negotiating party
     * @param negotiationTone The tone of negotiation
     * @return Confidence score
     */
    private static Decimal calculateConfidenceScore(String clauseType, String partyGoal, String negotiationTone) {
        Decimal score = 0.7; // Base confidence
        
        if (clauseType == 'Payment' || clauseType == 'Liability') {
            score += 0.2; // Higher confidence for common clauses
        }
        
        if (negotiationTone == 'Collaborative') {
            score += 0.1; // Higher confidence for collaborative approach
        }
        
        return Math.min(score, 1.0);
    }
}