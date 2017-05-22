public class CaseResultController extends CommunityControllerBase{

    public String title{set; get;}
    public String result {set; get;}
    
    private Map<String,String> params;
    
    public CaseResultController(){
        params = getParameters();
        
        Contact contact = [select Name from Contact where Id =: ContactID];
        Case c = [select Id,CaseNumber from Case where Id =: params.get('cid')];
        
        title = 'Thank you for your enquiry.';
        result = 'Your submission has been successfully received and will be processed as soon as possible.';
    }
    
    public PageReference casesView(){
        return redirectToCaseView();
    }
}