public class TwilioMessageListController {

    @AuraEnabled
    public static String getPhoneNo(String sObjectName, String recordId){
        String phoneNoField = getPhoneNoFieldBasedOnSObject(sObjectName);

        String query = 'SELECT ' + phoneNoField + ' FROM ' + sObjectName + ' WHERE Id =' + '\'' + recordId + '\'';
        SObject sobj = (SObject) Database.query(query)[0];
        return String.valueOf(sobj.get(phoneNoField));
    }

    private static String getPhoneNoFieldBasedOnSObject(String sObjectName) {
        Map<String, TwilioMessagesSObjectConfig__mdt> twilioMessagesSobjectConfig = new Map<String, TwilioMessagesSObjectConfig__mdt>([
            SELECT 
            SObjectName__c, TwilioPhoneNoField__c  
            FROM TwilioMessagesSObjectConfig__mdt
        ]);

        Map<String, String> phoneFieldBySObjectName = new Map<String, String>();

        for (TwilioMessagesSObjectConfig__mdt tmsc : twilioMessagesSobjectConfig.values()) {
            phoneFieldBySObjectName.put(tmsc.SObjectName__c, tmsc.TwilioPhoneNoField__c);
        }

        System.debug('twilioMessagesSobjectConfig = ' + twilioMessagesSobjectConfig);

        return phoneFieldBySObjectName.get(sObjectName);
    }

    @AuraEnabled
    public static String getTwilioMessages (Map<String, String> filters){
        return TwilioService.getMessages(filters);
    }


}