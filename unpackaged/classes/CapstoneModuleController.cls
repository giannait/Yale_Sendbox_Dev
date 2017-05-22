public class CapstoneModuleController extends ControllerBase{

    public Contact contact {set; get;}
    public Case c {set; get;}
    public Capstone_Module__c capstoneModule {set; get;}
    public List<Capstone_Module_Activity__c> capstoneModuleActivities {set; get;}
    public List<Residential_College__c> rc {set; get;}
    public String residentialCollegeName {set; get;}
    // public String today {set; get;}
    public boolean showPartner {set; get;}
    public boolean showAffliation {set; get;}
    public String currentMajor {set; get;}
    public String firstApprover {set; get;}
    public String firstApprover2 {set; get;}
    public String secondApprover {set; get;}
    public String firstApproverEmail {set; get;}
    public String firstApproverEmail2 {set; get;}
    public String secondApproverEmail {set; get;}
    public List<SelectOption> firstApproverEmails {set; get;}
    public List<SelectOption> secondApproverEmails {set; get;}
    
    private Map<String, String> params;
    private List<Contact> approvers;
    
    public CapstoneModuleController(){
        params = this.getParameters();
        
        contact = [select Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Current_Year__c,Length_of_Course__c,Major__c,Minor__c,NUSNET_ID__c from Contact where NUSNET_ID__c =: params.get('nid')];
        rc = [select Id,Name,Date_To__c,Date_From__c,Suite_No__c from Residential_College__c where Contact__c =: contact.Id and Date_To__c = null limit 1];
        
        if(rc.size() > 0){
            residentialCollegeName = rc.get(0).Name;
        }else{
            residentialCollegeName = '-';
        }

        currentMajor = contact.Major__c;
        
        firstApproverEmail = null;
        secondApproverEmail = null;
        
        firstApproverEmails = new List<SelectOption>();
        secondApproverEmails = new List<SelectOption>();
        
        firstApproverEmails.add(new SelectOption('', '--None--'));
        secondApproverEmails.add(new SelectOption('', '--None--'));
        
        approvers = [select Id,Name,Email from Contact where Type__c = 'Supervisor' and Status__c = 'Active'];
        for(Contact approver:approvers){
            firstApproverEmails.add(new SelectOption(approver.Id, approver.Name));
            secondApproverEmails.add(new SelectOption(approver.Id, approver.Name));
        }
        
        if(params.get('status') == 'new'){
            // today = Datetime.now().format('dd MMMM yyyy');
            showAffliation = false;
            
            capstoneModule = new Capstone_Module__c();
            capstoneModule.Project_Supervisor_Exterent__c = false;
            capstoneModule.Date__c = System.today();
            capstoneModule.Contact__c = contact.Id;
            
            capstoneModuleActivities = new List<Capstone_Module_Activity__c>();
            List<Capstone_Module_Activity_Template__c> templates = [select Activity__c, Action__c from Capstone_Module_Activity_Template__c];
            
            for(Capstone_Module_Activity_Template__c cmat : templates){
                Capstone_Module_Activity__c cma = new Capstone_Module_Activity__c();
                cma.Activity__c = cmat.Activity__c;
                cma.Action__c = cmat.Action__c;
                
                capstoneModuleActivities.add(cma);
            }
            
            c = new Case();
            c.ContactId = contact.Id;
            c.Department__c = params.get('department');
            c.Type_Of_Enquiry__c = params.get('toe');
            c.RecordTypeId = [select Id from RecordType where Name = 'Capstone Module'].Id;
            if(params.get('subdepartment') != 'null'){
                c.Sub_Department__c = params.get('subdepartment');    
            }            
        }else{
            capstoneModule = [select Id,Name,Case__c,Contact__c,Project_Supervisor_Name__c,Project_Supervisor_Email__c,Project_Supervisor_Exterent__c,Project_Supervisor_Affliation__c,Co_Supervisor_Name__c,Co_Supervisor_Email__c,Project_Title__c,Project_Description__c,Supervision__c from Capstone_Module__c where Id =: params.get('cid')];
            capstoneModuleActivities = [select Id,Name,Capstone_Module__c,Activity__c,Action__c,Check__c from Capstone_Module_Activity__c where Capstone_Module__c =: capstoneModule.Id];
            c = [select Id,ContactId,Department__c,Type_Of_Enquiry__c,RecordTypeId,Sub_Department__c,Subject,Status,Origin,Priority,Start_Date__c,End_Date__c from Case where Id =: capstoneModule.Case__c];
            
            Datetime dt = datetime.newInstance(capstoneModule.Date__c.Year(), capstoneModule.Date__c.Month(), capstoneModule.Date__c.Day());
            // today = dt.format('dd MMMM yyyy');
        }
    }
    
    public void firstApproverOnChange(){
        if(String.isNotEmpty(firstApprover) && firstApprover != ''){
            for(Contact approver : approvers){
                if(approver.Id == firstApprover){
            		firstApproverEmail = approver.Email;        
                }
            }
        }else{
            firstApproverEmail = null;
        }
    }

    public void secondApproverOnChange(){
        if(String.isNotEmpty(secondApprover) && secondApprover != ''){
            for(Contact approver : approvers){
                if(approver.Id == secondApprover){
            		secondApproverEmail = approver.Email;        
                }
            }
        }else{
            secondApproverEmail = null;
        }
    }
    
    public void affliationOnChange(){
        if(capstoneModule.Project_Supervisor_Exterent__c){
            showAffliation = true;  
        }else{
            showAffliation = false;
        }
    }
    
    public PageReference cancel(){
        return new PageReference('/CaseView?nid=' + params.get('nid'));
    }
    
    public PageReference save(){
        if(params.get('status') == 'new'){
            if(capstoneModule.Project_Supervisor_Exterent__c){
                if(String.isEmpty(secondApprover)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Co Supervisor cannot be null if the project supervisor is not from YALE!'));
                    return null;
                }
            }

            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;

            c.Subject = params.get('toe');
            c.Status = 'Open';
            c.Origin = 'Web';
            c.Priority = 'High';
            c.setOptions(dmo);
            
            if(capstoneModule.Project_Supervisor_Exterent__c){
                c.Level_1_Approver__c = firstApprover2;
                c.Level_1_Approver_Email__c = firstApproverEmail2;
                c.Level_2_Approver__c = secondApprover;
                c.Level_2_Approver_Email__c = secondApproverEmail;

                capstoneModule.Project_Supervisor_Name__c = firstApprover2;
                capstoneModule.Project_Supervisor_Email__c = firstApproverEmail2;

                if(String.isNotEmpty(secondApprover)){
                    capstoneModule.Co_Supervisor_Name__c = [select Name from Contact where Id =: secondApprover].Name;
                    capstoneModule.Co_Supervisor_Email__c = c.Level_2_Approver_Email__c;
                }
            }else{
                System.debug('approver : ' + firstApprover);
                System.debug('approver email : ' + firstApproverEmail);

                c.Level_1_Approver__c = [select Name from Contact where Id =: firstApprover].Name;
                c.Level_1_Approver_Email__c = firstApproverEmail;

                capstoneModule.Project_Supervisor_Name__c = c.Level_1_Approver__c;
                capstoneModule.Project_Supervisor_Email__c = firstApproverEmail;
            }

            
            c.Capstone_Approval_Status__c = 'First Level Approval';
            c.Capstone_Project_Title__c = capstoneModule.Project_Title__c;
            c.Capstone_Project_Description__c = capstoneModule.Project_Description__c;
            c.Capstone_Project_Supervision__c = capstoneModule.Supervision__c;
            insert c;
            
            capstoneModule.Case__c = c.Id;
            insert capstoneModule;
            
            /*
            for(Capstone_Module_Activity__c cma : capstoneModuleActivities){
                cma.Capstone_Module__c = capstoneModule.Id;
            }
            
            insert capstoneModuleActivities;
            */
        }else{
            update capstoneModule;
            //update capstoneModuleActivities;
        }
        
        return new PageReference('/CaseView?nid=' + params.get('nid'));
    }
}