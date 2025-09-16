/**
 * ADDED: Simple Microsoft Teams webhook notifier (example integration).
 * Replace the WEBHOOK_URL with a real secret.
 */
public with sharing class TeamsNotifier {
    private static final String WEBHOOK_URL = 'https://outlook.office.com/webhook/xxxxxxxxx/IncomingWebhook/yyyyyyyy/zzzzzzzz';

    public static void sendMessage(String text) {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(WEBHOOK_URL);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            Map<String, Object> payload = new Map<String, Object>();
            payload.put('@type', 'MessageCard');
            payload.put('@context', 'http://schema.org/extensions');
            payload.put('summary', 'AI Legal Contract Analyzer');
            payload.put('text', text);
            req.setBody(JSON.serialize(payload));
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Teams response: ' + res.getStatus() + ' ' + res.getBody());
        } catch (Exception e) {
            System.debug('Teams sendMessage error: ' + e.getMessage());
        }
    }
}


