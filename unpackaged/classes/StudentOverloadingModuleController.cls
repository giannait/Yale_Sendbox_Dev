public class StudentOverloadingModuleController extends CommunityControllerBase{
	
    public Contact contact {set; get;}
    public Case c {set; get;}
    public List<Residential_College__c> rc {set; get;}
    public String residentialCollegeName {set; get;}
    public String indexString {set; get;}
    public List<Student_Overloading_Module__c> studentOverloadingModules {set; get;}
    
    private Map<String, String> params;
    
    public StudentOverloadingModuleController(){
        params = this.getParameters();
        
        contact = [select Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Current_Year__c,Length_of_Course__c,Semester__c,Major__c from Contact where Id =: ContactID];
        rc = [select Id,Name,Date_To__c,Date_From__c,Suite_No__c,Residential_College_Master__r.Name from Residential_College__c where Contact__c =: contact.Id and Date_To__c = null limit 1];
        
        if(rc.size() > 0){
            residentialCollegeName = rc.get(0).Residential_College_Master__r.Name;
        }else{
            residentialCollegeName = '-';
        }
        
        c = new Case();
        c.ContactId = contact.Id;
        c.Department__c = params.get('department');
        c.Type_Of_Enquiry__c = params.get('toe');
        c.RecordTypeId = [select Id from RecordType where Name = 'Student Overloading Module'].Id;
        if(params.get('subdepartment') != 'null'){
            c.Sub_Department__c = params.get('subdepartment');    
        }
        
        studentOverloadingModules = new List<Student_Overloading_Module__c>();
        studentOverloadingModules.add(new Student_Overloading_Module__c());
    }
    
    public void addRow(){
        studentOverloadingModules.add(new Student_Overloading_Module__c());
    }
    
    public void deleteRow(){
        Integer index = Integer.valueOf(indexString);
        studentOverloadingModules.remove(index - 1);
    }
    
    public PageReference save(){
        PageReference pr = null;
        
        List<Student_Overloading_Module__c> saveOverloadingModules = new List<Student_Overloading_Module__c>();
        System.Savepoint sp = Database.setSavepoint();
        
        try{
            c.Subject = params.get('toe');
            c.Status = 'Open';
            c.Origin = 'Web';
            c.Priority = 'High';
            c.setOptions(dmo);
            insert c;
            
            for(Student_Overloading_Module__c overloadingModule : studentOverloadingModules){
                if(String.isNotEmpty(overloadingModule.Academic_Year__c)){
                    overloadingModule.Case__c = c.Id;
                    overloadingModule.Contact__c = contact.Id;
                    
                    saveOverloadingModules.add(overloadingModule);
                }
            }
            
            if(saveOverloadingModules.size() > 0) insert saveOverloadingModules;
            
            pr = cancel();
        }catch(Exception e){
            Database.rollback(sp);
            this.showErrorMessage(e.getMessage());
        }
        
        return pr;
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
}