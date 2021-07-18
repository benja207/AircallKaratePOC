package examples.users;

import com.intuit.karate.junit5.Karate;

class ContactsRunner {
    
    @Karate.Test
    Karate testContacts() {
        return Karate.run("contacts").relativeTo(getClass());
    }    

}
