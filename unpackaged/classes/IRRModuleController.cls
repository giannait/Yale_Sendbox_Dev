public class IRRModuleController extends CommunityControllerBase {

    public Contact contact {set; get;}
    public Case c {set; get;}
    public IRR_Module__c irr{set; get;}
    public List<Residential_College__c> rc {set; get;}
    public String residentialCollegeName {set; get;}
    //public String today {set; get;}
    public boolean showPartner {set; get;}
    public String studentID {set; get;}
    
    private Map<String, String> params;
    
    public IRRModuleController(){
        params = this.getParameters();
        
        contact = [select Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Current_Year__c,Degree_Name__c,Length_of_Course__c,Major__c,Minor__c from Contact where Id =: ContactID];
        rc = [select Id,Name,Date_To__c,Date_From__c,Suite_No__c,Residential_College_Master__r.Name from Residential_College__c where Contact__c =: contact.Id and Date_To__c = null limit 1];
        
        if(rc.size() > 0){
            residentialCollegeName = rc.get(0).Residential_College_Master__r.Name;
        }else{
            residentialCollegeName = '-';
        }

        if(params.get('status') == 'new'){
            //today = Datetime.now().format('dd MMMM yyyy');
            
            irr = new IRR_Module__c();
            irr.Contact__c = contact.Id;
            irr.Date__c = System.today();
            
            c = new Case();
            c.ContactId = contact.Id;
            c.Department__c = params.get('department');
            c.Type_Of_Enquiry__c = params.get('toe');
            c.RecordTypeId = [select Id from RecordType where Name = 'IRR Module'].Id;
            if(params.get('subdepartment') != 'null'){
                c.Sub_Department__c = params.get('subdepartment');    
            }
            
            showPartner = false;
        }else{
            irr = [select Id,Name,Case__c,Contact__c,Project_Type__c,Project_Name__c,Project_Description__c,Partner__c,Partner_Name__c,Partner_Residential_College__c,Activities__c,Schedule__c,Anticipated__c,Goals__c,Faculty_Supervisor_Name__c,Faculty_Supervisor_Email__c,Faculty_Supervisor_Division__c from IRR_Module__c where Id =: params.get('iid')];
            c = [select Id,ContactId,Department__c,Type_Of_Enquiry__c,RecordTypeId,Sub_Department__c,Subject,Status,Origin,Priority,Start_Date__c,End_Date__c from Case where Id =: irr.Case__c];
            
            Datetime dt = datetime.newInstance(irr.Date__c.Year(), irr.Date__c.Month(), irr.Date__c.Day());
            //today = dt.format('dd MMMM yyyy');
            
            projectTypeOnchange();
        }
    }
    
    public void projectTypeOnchange(){
        if(irr.Project_Type__c == '2MC Independent Reading and Research'){
            showPartner = true;
        }else{
            showPartner = false;
        }
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
    
    public PageReference save(){
        if(params.get('status') == 'new'){
            if(irr.Individual_Partner_Project__c == 'Partner'){
                if(String.isEmpty(studentID)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Partner ID cannot be null!'));
                    return null;
                }else{
                    List<Contact> students = [select Id from Contact where Student_Identity__c =: studentID];
                    if(students.size() > 0){
                        irr.Partner__c = students.get(0).Id;
                    }else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Partner ID Cannot be found!'));
                        return null;  
                    }
                }
            }


            c.Subject = params.get('toe');
            c.Status = 'Open';
            c.Origin = 'Web';
            c.Priority = 'High';
            c.setOptions(dmo);
            insert c;
            
            irr.Case__c = c.Id;
            insert irr;
        }else{
            update irr;
        }
        
        return redirectToCaseView();
    }
}