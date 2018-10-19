@RestResource(urlMapping='/Username/*')
global with sharing class UserName {

    @HttpGet
    global static String GiveMeUserName(){

        RestRequest request = RestContext.request;
        String paramToWait = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Integer secondsToWait = Integer.valueOf(paramToWait);

        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        while ((finishTime-startTime) < secondsToWait * 1000) {
            //sleep for parameter x secs
            finishTime = DateTime.now().getTime();
        }

        return 'My Name is a secret';
    }
}