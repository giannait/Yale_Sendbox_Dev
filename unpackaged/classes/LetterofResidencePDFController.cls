public class LetterofResidencePDFController extends ControllerBase{
    public Case c {set; get;}
    public Contact contact {set; get;}
    public Residential_College__c rc {set; get;}
    public Passport__c passport {set; get;}
    public String today {set; get;}
    
    private Map<String, String> params;
    
    public LetterofResidencePDFController(){
        params = this.getParameters();
        today = Datetime.now().format('dd MMMM yyyy');
        
        c = [select Id,ContactId,Start_Date__c from Case where Id =: params.get('id')];
        contact = [select Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Current_Year__c,Length_of_Course__c,Degree_Name__c from Contact where Id =: c.ContactId];
        rc = [select Id,Name,Date_To__c,Date_From__c,Suite_No__c from Residential_College__c where Contact__c =: contact.Id and Date_To__c = null limit 1];
        
        List<Passport__c> passportList = [select Id,Name,Date_of_Expiry__c from Passport__c where Status__c = 'Active'];
        if(passportList.size() > 0){
            passport = passportList.get(0);
        }else{
            passport = new Passport__c();
        }
    }
}