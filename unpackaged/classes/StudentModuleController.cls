public class StudentModuleController extends CommunityControllerBase{

    public List<Student_Module__c> studentModules {set; get;}
    public List<Student_Module__c> addStudentModules {set; get;}
    public Case c {set; get;}
    public Contact contact {set; get;}
    public List<Residential_College__c> rc {set; get;}
    public String residentialCollegeName {set; get;}
    public String indexString {set; get;}
    public Attachment attachment {set; get;}
    
    private Map<String, String> params;
    
    public StudentModuleController(){
        params = this.getParameters();
        
        attachment = new Attachment();
        contact = [select Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Current_Year__c,Length_of_Course__c,Semester__c,Major__c from Contact where Id =: ContactID];
        rc = [select Id,Name,Date_To__c,Date_From__c,Suite_No__c,Residential_College_Master__r.Name from Residential_College__c where Contact__c =: contact.Id and Date_To__c = null limit 1];
        
        if(rc.size() > 0){
            residentialCollegeName = rc.get(0).Residential_College_Master__r.Name;
        }else{
            residentialCollegeName = '-';
        }
        
        addStudentModules = new List<Student_Module__c>();
        addStudentModules.add(new Student_Module__c());
        
        studentModules = new List<Student_Module__c>();
        studentModules.add(new Student_Module__c());
        
        c = new Case();
        c.ContactId = contact.Id;
        c.Department__c = params.get('department');
        c.Type_Of_Enquiry__c = params.get('toe');
        c.RecordTypeId = [select Id from RecordType where Name = 'Student Module'].Id;
        if(params.get('subdepartment') != 'null'){
            c.Sub_Department__c = params.get('subdepartment');    
        }
    }
    
    public void addModule(){
        addStudentModules.add(new Student_Module__c());
    }

    public void deleteRow(){
        Integer index = Integer.valueOf(indexString);
        addStudentModules.remove(index - 1);
    }
    
    public void addDropModule(){
        studentModules.add(new Student_Module__c());
    }
    
    public void deleteRowDropModule(){
        Integer index = Integer.valueOf(indexString);
        studentModules.remove(index - 1);
    }
    
    public PageReference save(){
        List<Student_Module__c> studentModuleSave = new List<Student_Module__c>();
        
        c.Subject = params.get('toe');
        c.Status = 'Open';
        c.Origin = 'Web';
        c.Priority = 'High';
        c.Approval_Status__c = 'Pending VR';
        c.setOptions(dmo);
        insert c;
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitted for approval. Please approve.');
        req.setObjectId(c.Id);
        Approval.process(req);
        
        if(attachment.Body != null){
            try{
            	attachment.ParentId = c.Id;
            	insert attachment;    
                
                
            }catch(Exception e){
            	System.debug('Upload erroe : ' + e.getMessage());
            }finally{
                attachment = new Attachment();
            }
        }
        
        for(Student_Module__c module : addStudentModules){
            if(String.isNotEmpty(module.Module_Code__c)){
                module.Contact__c = contact.Id;
                module.Case__c = c.Id;
                module.Current_Year__c = contact.Current_Year__c;
                
                studentModuleSave.add(module);
            }
        }
        
        for(Student_Module__c studentModule : studentModules){
            if(String.isNotEmpty(studentModule.Module_Code__c)){
                studentModule.isDeleted__c = true;
                studentModule.Contact__c = contact.Id;
                studentModule.Case__c = c.Id;
                studentModule.Current_Year__c = contact.Current_Year__c;
                
                studentModuleSave.add(studentModule);
            }
        }
        
        insert studentModuleSave;
        
        return cancel();
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
}