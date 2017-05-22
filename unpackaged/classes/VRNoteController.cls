public class VRNoteController extends CommunityControllerBase{
    
    public Contact contact {set; get;}
    public Case c {set; get;}
    public Vice_Rector_Note__c vrNote {set; get;}
    public List<Residential_College__c> rc {set; get;}
    public String residentialCollegeName {set; get;}
    public Attachment attachment {set; get;}
    public List<Vice_Rector_Note_Module__c> modules {set; get;}
    public String indexString {set; get;}
    
    public Boolean showHealthCenter {set; get;}
    public Boolean showHealthCenterDate {set; get;}
    public Boolean showTravelRequest {set; get;}
    
    private Map<String, String> params;
    private List<Vice_Rector_Note_Module__c> deletedModules {set; get;}
    
    public VRNoteController(){
        params = this.getParameters();

        contact = [select Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Current_Year__c,Length_of_Course__c,Major__c from Contact where Id =: ContactID];
        rc = [select Id,Name,Date_To__c,Date_From__c,Suite_No__c,Residential_College_Master__r.Name from Residential_College__c where Contact__c =: contact.Id and Date_To__c = null limit 1];
        
        if(rc.size() > 0){
            residentialCollegeName = rc.get(0).Residential_College_Master__r.Name;
        }else{
            residentialCollegeName = '-';
        }

        attachment = new Attachment();
        deletedModules = new List<Vice_Rector_Note_Module__c>();
        
        if(params.get('status') == 'new'){
            vrNote = new Vice_Rector_Note__c();
            vrNote.Date_Issued__c = System.today();
            vrNote.Student__c = contact.Id;
            vrNote.Department__c = params.get('department');
            vrNote.Sub_Department__c = params.get('subdepartment');
            
            c = new Case();
            c.ContactId = contact.Id;
            c.Department__c = params.get('department');
            c.Type_Of_Enquiry__c = 'Request for VR Note';
            c.RecordTypeId = [select Id from RecordType where Name = 'Vice Rector Note'].Id;
            if(params.get('subdepartment') != 'null'){
                c.Sub_Department__c = params.get('subdepartment');    
            }
            
            modules = new List<Vice_Rector_Note_Module__c>();
            modules.add(new Vice_Rector_Note_Module__c());
            
            showHealthCenter = false;
            showHealthCenterDate = false;
            showTravelRequest = false;
        }else{
//            vrNote = [select Id,Description__c,Student__c,Department__c,Sub_Department__c,Date_Issued__c,Type__c,Health_Centre__c,Health_Centre_Date__c,From_Date__c,To_Date__c,Case__c from Vice_Rector_Note__c where Id =: params.get('vid')];
//            c = [select Id,ContactId,Department__c,Type_Of_Enquiry__c,RecordTypeId,Sub_Department__c,Subject,Status,Origin,Priority,Start_Date__c,End_Date__c from Case where Id =: vrNote.Case__c];
//            modules = [select Id,Name,Assignment__c,Assignment_Due_Date__c,Instructor_Email__c,Instructor_Name__c,Title__c,Postponement__c,Proposed_Date__c,Vice_Rector_Note__c,Postponement_Reason__c from Vice_Rector_Note_Module__c where Vice_Rector_Note__c =: vrNote.Id];
//
//            Datetime dt = datetime.newInstance(vrNote.Date_Issued__c.Year(), vrNote.Date_Issued__c.Month(), vrNote.Date_Issued__c.Day());
//
//            if(vrNote.From_Date__c == null){
//                showHealthCenter = true;
//
//                if(vrNote.Health_Centre__c == 'Yes'){
//                    showHealthCenterDate = true;
//                }
//            }else{
//                showTravelRequest = true;
//            }
        }
    }

    public void addModule(){
        modules.add(new Vice_Rector_Note_Module__c());
    }
    
    public void deleteModule(){
        Integer index = Integer.valueOf(indexString);
        
        Vice_Rector_Note_Module__c module = modules.get(index - 1);
        modules.remove(index - 1);
        
        if(module.Vice_Rector_Note__c != null){
            deletedModules.add(module);
        }
    }
    
    public PageReference save(){
        if(params.get('status') == 'new'){
            c.Subject = 'Request for VR Note';
            c.Status = 'Open';
            c.Origin = 'Web';
            c.Priority = 'High';
            c.setOptions(dmo);
            insert c;
            
            vrNote.Case__c = c.Id;
            if(vrNote.Type__c != 'Medical - Physical / Mental Health'){
                vrNote.Health_Centre__c = 'No';
            }

            insert vrNote;

            if(attachment.Body != null){
                attachment.ParentId = vrNote.Id;
                insert attachment;

                attachment = new Attachment();
            }
        }else{
            update vrNote;
        }
        
        if(modules.size() > 0){
            for(Vice_Rector_Note_Module__c module : modules){
                if(module.Vice_Rector_Note__c == null){
                    module.Vice_Rector_Note__c = vrNote.Id;
                    insert module;
                }else{
                    update module;
                }
            }
        }
        
        if(deletedModules.size() > 0){
            delete deletedModules;
        }
        
        return cancel();
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
}