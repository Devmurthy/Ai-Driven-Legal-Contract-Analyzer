/**
 * ADDED: Simple Slack webhook notifier (example integration).
 * Replace the WEBHOOK_URL with a real secret (Custom Metadata/Named Credential recommended).
 */
public with sharing class SlackNotifier {
    private static final String WEBHOOK_URL = 'https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX';

    public static void sendMessage(String text) {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(WEBHOOK_URL);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(new Map<String, Object>{ 'text' => text }));
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Slack response: ' + res.getStatus() + ' ' + res.getBody());
        } catch (Exception e) {
            System.debug('Slack sendMessage error: ' + e.getMessage());
        }
    }
}


