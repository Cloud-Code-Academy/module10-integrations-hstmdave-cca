public with sharing class ContactTriggerHandler {

    private static Set<Id> previouslyProcessedId = new Set<Id>(); // using a set to help prevent touching the same record multiple times
    
    // When a contact is inserted
	// if DummyJSON_Id__c is null, generate a random number between 0 and 100 and set this as the contact's DummyJSON_Id__c value

    public static void jsonIdIsNull (List<Contact> newContacts) {

        List<Contact> contactsToUpdate = new List<Contact>();
        
        for(Contact c : newContacts) {
            if(c.DummyJSON_Id__c == null) {
                c.DummyJSON_Id__c = String.valueOf((Integer)(Math.random() * 101));
                contactsToUpdate.add(c);
            }
        }
    }

	//When a contact is inserted
	// if DummyJSON_Id__c is less than or equal to 100, call the getDummyJSONUserFromId API
    // getDummyJSONUserFromId takes a Set<String> as input for the callout "record" Id's

    public static void jsonIdLessThan101 (List<Contact> newContacts) {
        if(System.isFuture()) {
            return;
        }

        String dummyJsonId = '';
        for(Contact c : newContacts) {
            if(c.DummyJSON_Id__c != null && Integer.valueOf(c.DummyJSON_Id__c) <= 100 && !previouslyProcessedId.contains(c.Id)) {
                dummyJsonId = c.DummyJSON_Id__c;
                previouslyProcessedId.add(c.Id);
                DummyJSONCallout.getDummyJSONUserFromId(dummyJsonId);
            }
        }
    }


	//When a contact is updated
	// if DummyJSON_Id__c is greater than 100, call the postCreateDummyJSONUser API
    // postCreateDummyJSONUser takes Set<String> of Contact Id's as input

    public static void jsonIdGreaterThan100 (List<Contact> contactList, Map<Id,Contact> contactOldMap) {
        if(System.isFuture()) {
            return;
        }

        String contactId = '';
        for(Contact c : contactList) {
            if(c.DummyJSON_Id__c != null && Integer.valueOf(c.DummyJSON_Id__c) > 100 && !previouslyProcessedId.contains(c.Id) ) {
                contactId = String.valueOf(c.Id);
                previouslyProcessedId.add(c.Id);
                DummyJSONCallout.postCreateDummyJSONUser(contactId);
            }
        }
    }
}