package examples.users;

import com.intuit.karate.junit5.Karate;

class TeamsRunner {
    
    @Karate.Test
    Karate testTeams() {
        return Karate.run("teams").relativeTo(getClass());
    }    

}
