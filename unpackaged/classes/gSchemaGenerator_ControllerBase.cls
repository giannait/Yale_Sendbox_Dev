public virtual class gSchemaGenerator_ControllerBase {

    public Boolean isSystemAdmin {set; get;}
    public final String defaultAPIVersion = 'v38.0';

    public gSchemaGenerator_ControllerBase(){
        Profile profile = [select Id,Name from Profile where Id =: UserInfo.getProfileId()];

        if(profile.Name == 'System Administrator'){
            isSystemAdmin = true;
        }else{
            isSystemAdmin = false;
        }
    }

    public String generateMetadata(String apiVersion, String query){
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();

        Http h = new Http();
        HttpRequest hr = new HttpRequest();
        hr.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        hr.setTimeout(60000);
        hr.setEndpoint(baseURL + '/services/data/' + apiVersion + '/tooling/query?q=' + query);
        hr.setMethod('GET');
        HttpResponse r = h.send(hr);

        return r.getBody();
    }
}