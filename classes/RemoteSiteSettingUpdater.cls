public class RemoteSiteSettingUpdater {

    // Define the API version
    final static String API_VERSION = '59.0';

    public static void updateRemoteSiteSetting() {
		String sessionId = UserInfo.getSessionId();
        System.debug('Session ID: ' + sessionId);
        // Define the remote site setting name and the new URL
        String fullName = 'ContractingNA';
        String newUrl = 'httpsexamplecom';

        // Create a map to store the setting name and the new URL
        Map<String, String> settingMap = new Map<String, String>();
        settingMap.put('fullName', fullName);
        settingMap.put('url', newUrl);
		System.debug('fullName: ' + fullName);
		System.debug('newUrl: ' + newUrl);
        // Generate the SOAP request body using the setting map
        String body = generateEnvelope(settingMap);

        // Get the base URL of the org
        String baseUrl = URL.getOrgDomainUrl().toExternalForm();

        // Construct the endpoint URL for the Metadata API
        String endpoint = baseUrl + '/services/Soap/m/' + API_VERSION + '/';

        // Create a new HttpRequest
        HttpRequest req = new HttpRequest();

        // Set the endpoint, method, headers, and body
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('SOAPAction', 'update');
        req.setHeader('Content-Type', 'text/xml');
        req.setBody(body);
        // Send the request and get the response
        HttpResponse res = new Http().send(req);

        // Print the status code and the response body
        System.debug('Status code: ' + res.getStatusCode());
        System.debug('Response: ' + res.getBody());
        
    }

    public static String generateEnvelope(Map<String, String> settingMap) {
    return '<?xml version="1.0" encoding="UTF-8"?>\n' +
           '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ' +
           'xmlns:apex="http://soap.sforce.com/2006/08/apex" ' +
           'xmlns:cmd="http://soap.sforce.com/2006/04/metadata" ' +
           'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' +
           'xmlns:ns="http://soap.sforce.com/2006/04/metadata">\n' +
           '    <soapenv:Header>\n' +
           '        <cmd:SessionHeader>\n' +
           '            <cmd:sessionId>' + UserInfo.getSessionId() + '</cmd:sessionId>\n' +
           '        </cmd:SessionHeader>\n' +
           '    </soapenv:Header>\n' +
           '    <soapenv:Body>\n' +
           '        <update xmlns="http://soap.sforce.com/2006/04/metadata">\n' +
           '            <metadata xsi:type="ns:RemoteSiteSetting">\n' +
           '                <ns:fullName>' + settingMap.get('fullName') + '</ns:fullName>\n' +
           '                <ns:url>' + settingMap.get('url') + '</ns:url>\n' +
           '            </metadata>\n' +
           '        </update>\n' +
           '    </soapenv:Body>\n' +
           '</soapenv:Envelope>';
}
}