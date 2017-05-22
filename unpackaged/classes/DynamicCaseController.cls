public class DynamicCaseController extends CommunityControllerBase{
    
    public Case c {set; get;}
    public Attachment attachment {set; get;}
    public Contact contact {set; get;}
    public List<Residential_College__c> rc {set; get;}
    public String residentialCollegeName {set; get;}
    public Integer yos {set; get;} // yos =Year of Study
    public Passport__c passport {set; get;}
    public CaseComment cc {set; get;}
    public List<CaseComment> ccList {set; get;}
    public String department {set; get;}
    public String subDepartment {set; get;}
    public String typeOfEnquiry {set; get;}
    public Boolean hardcopyNeed {set; get;}
    //public String today {set; get;}
    
    public Boolean showEnrolment {set; get;}
    public Boolean showResidence {set; get;}
    public Boolean showNS {set; get;}
    
    private Map<String, String> params;
    
    public DynamicCaseController(){
        params = this.getParameters();
        
        //today = Datetime.now().format('dd MMMM yyyy');
        department = params.get('department');
        subDepartment = params.get('subdepartment');
        typeOfEnquiry = params.get('toe');
        
        contact = [select Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Current_Year__c,Length_of_Course__c,Degree_Name__c,NUSNET_ID__c from Contact where Id =: ContactID];
        rc = [select Id,Name,Date_To__c,Date_From__c,Suite_No__c,Residential_College_Master__r.Name from Residential_College__c where Contact__c =: contact.Id and Date_To__c = null limit 1];
        
        if(rc.size() > 0){
            residentialCollegeName = rc.get(0).Residential_College_Master__r.Name;
        }else{
            residentialCollegeName = '-';
        }

        if(contact.Matric_Year__c == null){
            yos = 0;
        }else{
            yos = Integer.valueOf(contact.Matric_Year__c) - Date.today().year();
            yos = (yos == 0 ? 1 : yos);
        }

        hardcopyNeed = false;
        
        c = new Case();
        c.ContactId = contact.Id;
        c.Department__c = department;
        c.Type_Of_Enquiry__c = params.get('toe');
        if(params.get('subdepartment') != 'null'){
            c.Sub_Department__c = params.get('subdepartment');    
        }
        
        attachment = new Attachment();
        cc = new CaseComment();
        
        hideAllSection();

        if(typeOfEnquiry.equalsIgnoreCase('Request for Student Status Letter (Additional remarks needed)')){
            showEnrolment = true;
            c.RecordTypeId = [select Id from RecordType where Name = 'Letter of Enrolment'].Id;
            
            List<Passport__c> passportList = [select Id,Name,Date_of_Expiry__c from Passport__c where Status__c = 'Active'];
            if(passportList.size() > 0){
                passport = passportList.get(0);
            }else{
                passport = new Passport__c();
            }
        }else if(typeOfEnquiry.equalsIgnoreCase('Request for Letter of Residence')){
            showResidence = true;
            
            c.RecordTypeId = [select Id from RecordType where Name = 'Letter of Residence'].Id;
            
            List<Passport__c> passportList = [select Id,Name,Date_of_Expiry__c from Passport__c where Status__c = 'Active'];
            if(passportList.size() > 0){
                passport = passportList.get(0);
            }else{
                passport = new Passport__c();
            }
        }else if(typeOfEnquiry.equalsIgnoreCase('NS Deferment Letter')){
            showNS = true;
            c.RecordTypeId = [select Id from RecordType where Name = 'NS Deferment Letter'].Id;
        }
    }
    
    private void hideAllSection(){
        showEnrolment = false;
        showResidence = false;
        showNS = false;
    }
    
    public PageReference save(){
        PageReference result = null;
        
        try{
            c.Subject = c.Type_Of_Enquiry__c;
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
            
            if(typeOfEnquiry.equalsIgnoreCase('NS Deferment Letter') || typeOfEnquiry.equalsIgnoreCase('Request for Student Status Letter (Additional remarks needed)')){
                if(attachment.Body != null){
                    attachment.ParentId = c.Id;
                    insert attachment;    
                }
            }

            PageReference pr = Page.CaseResult;
            pr.setRedirect(true);
            pr.getParameters().put('cid', c.Id);
            result = pr;
        }catch(Exception e){
            if(String.isNotEmpty(c.Id)){
                delete c;    
            }
            
            showErrorMessage('Case Saving Error : ' + e.getMessage());
        }finally{
            attachment.Body = null;
        }
        
        return result;
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
}