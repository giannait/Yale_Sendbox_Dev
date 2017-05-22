public class VRNotePDFController extends ControllerBase{
    
    public Contact contact {set; get;}
    public Case c {set; get;}
    public Vice_Rector_Note__c vrNote {set; get;}
    public Residential_College__c rc {set; get;}
    public String dt {set; get;}
    
    private Map<String, String> params;
    
    public VRNotePDFController(){
        params = this.getParameters();
        
        c = [select Id,ContactId,Department__c,Type_Of_Enquiry__c,RecordTypeId,Sub_Department__c,Subject,Status,Origin,Priority from Case where Id =: params.get('cid')];
        contact = [select Id,Name,Student_Identity__c,Email,NRIC__c,Matric_Year__c,Current_Year__c,Length_of_Course__c,Major__c from Contact where Id =: c.ContactId];
        rc = [select Id,Name,Date_To__c,Date_From__c,Suite_No__c,Residential_College_Master__r.Name from Residential_College__c where Contact__c =: contact.Id and Date_To__c = null limit 1];
        vrNote = [select Id,Student__c,Department__c,Sub_Department__c,Date_Issued__c,Description__c,Type__c,Health_Centre__c,Health_Centre_Date__c,From_Date__c,To_Date__c,Case__c,VR__c from Vice_Rector_Note__c where Id =: params.get('vid')];
        
        Date d = vrNote.Date_Issued__c;
        Datetime dd = datetime.newInstance(d.year(), d.month(),d.day());
        dt = dd.format('dd MMMM yyyy');
    }
}