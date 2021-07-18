function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://api.aircall.io/v1'
    }
    if (env == 'dev') {
      config.api_string = 'karate@karatest.com'
      config.userPassword = 'karate123'
    } 
     if (env == 'qa') {
      config.userEmail = 'karate2@test.com'
      config.userPassword = 'karate456'
    }

  

  const api_string = "ZGU3NmEzMDE1MWVmYjU0M2YxODYxYWVmYzU5M2NjZTM6YzE3ZTljZDQzMDgxMWI4ZGE3NjI1MDcwMzA0MzIzYWM="
  karate.configure('headers', {Authorization: 'Basic ' + api_string})

  return config;
}