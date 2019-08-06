public class TwilioService {
    public static final String HTTP_METHOD_GET = 'GET';

    @AuraEnabled
    public static String getMessages(Map<String, String> optionalFilters) {
        
        String filterString = '';
        if (optionalFilters != null) {
            filterString = getFilterUrlString(optionalFilters);
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:TWILIO_NC' + filterString); //Using named credential "TWILIO_NC" with endpoint and credentials using basic auth.
        req.setMethod(HTTP_METHOD_GET);

        System.debug('req = ' + req);

        Http http = new Http();
        HttpResponse response = new HttpResponse();
        response = http.send(req);

        return response.getBody();
    }

    private static String getFilterUrlString(Map<String, String> filters) {
        String filterString = '';
        Integer noOfFilters = 0;
        for (String filterKey : filters.keySet()) {
            if (noOfFilters == 0) {
                filterString += '?';
            } else {
                filterString += '&';
            }
            filterString += filterKey + '=' + filters.get(filterKey);
            noOfFilters++;
        }
        return filterString;
    }

    private class TwilioMessage {
        public String body;
        public Date date_sent;
        public String status;
    }

}