public class GeneralEnquiryFormController extends CommunityControllerBase{
    
    public Case c {set; get;}
    public Attachment attachment {set; get;}
    public Contact contact {set; get;}
    public CaseComment cc {set; get;}
    public String department {set; get;}
    public String subDepartment {set; get;}
    public String typeOfEnquiry {set; get;}

    public List<SelectOption> toeOptions {set; get;}
    
    private Map<String, String> params;
    private List<Type_of_Enquiry__c> toes;
    
    public GeneralEnquiryFormController(){
        params = this.getParameters();
        
        department = params.get('department');
        subDepartment = params.get('subdepartment');
        typeOfEnquiry = '';
        
        contact = [select Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Length_of_Course__c,Degree_Name__c,NUSNET_ID__c,Current_Year__c from Contact where Id =: ContactID];

        toes = [
            select
                Id, Name, Active__c
            from Type_of_Enquiry__c
            where Department__r.Parent_Department__r.Name =: department and Department__r.Name =: subDepartment
        ];

        toeOptions = new List<SelectOption>();
        for(Type_of_Enquiry__c toe : toes){
            if(toe.Active__c){
                toeOptions.add(new SelectOption(toe.Name, toe.Name));
            }
        }

        c = new Case();
        c.ContactId = contact.Id;
        c.Department__c = department;
        if(params.get('subdepartment') != 'null'){
            c.Sub_Department__c = subDepartment;
        }
        c.Type_Of_Enquiry__c = params.get('toe');
        c.RecordTypeId = [select Id from RecordType where Name = 'General Enquiry'].Id;

        attachment = new Attachment();
        cc = new CaseComment();
    }
    
    public PageReference save(){
        try{
            c.Type_Of_Enquiry__c = params.get('toe');
            c.Subject = typeOfEnquiry != 'General Enquiry' ? 'General Enquiry - ' + typeOfEnquiry : typeOfEnquiry;
            c.Status = 'Open';
            c.Origin = 'Web';
            c.Priority = 'High';
            c.setOptions(dmo);
            insert c;
                
            if(cc.CommentBody != null && cc.CommentBody != ''){
                cc.IsPublished = true;
                cc.ParentId = c.Id;
                
                insert cc;
            }
            
            if(attachment.Body != null){
                attachment.ParentId = c.Id;
                insert attachment;    
            }
            
            return cancel();    
        }catch(Exception e){
            System.debug('error : ' + e.getMessage());
        }
        
        return null;
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
}