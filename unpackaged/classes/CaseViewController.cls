// For testing
// https://c.cs31.visual.force.com/apex/CaseView?sid=SID201609170000001

public class CaseViewController extends CommunityControllerBase{
    
    public List<Case> cases {set; get;}
    public Contact contact {set; get;}
    public List<Progress_Report__c> progressReports {set; get;}
    public List<Vice_Rector_Note__c> vrNotes {set; get;}
    public List<Plan_Of_Study__c> pos {set; get;}
    
    public Boolean showVRNote {set; get;}
    public Boolean showProgressReport {set; get;}
    
    private Map<String, String> params;
    
    public CaseViewController(){
        params = this.getParameters();
        
        contact = [select Id,Name,Student_Identity__c from Contact where Id =: ContactID];
        cases = [select Id,Department__c,Sub_Department__c,CaseNumber,Status,Type_of_Enquiry__c,Description,ContactId,CreatedDate from Case where ContactId =: contact.Id and Status = 'Open' order by LastModifiedDate desc];
        vrNotes = [select Id,Type__c,Date_Issued__c,Name from Vice_Rector_Note__c where Student__c =: contact.Id];
        pos = [select Id,Name,Year_Of_Study__c,Head_of_Studies__c,Capstone_Advisor__c,Faculty_Advisor__c from Plan_Of_Study__c where Contact__c =: contact.Id];
        this.loadProgressReports();
    }
    
    private void loadProgressReports(){
        progressReports = [select Id,Name,Academic_Advising__c,Capstone_Advisor__c,Head_of_Study__c,Year_of_Study__c,Faculty_Advisor__c from Progress_Report__c where Student__c =: contact.Id  and isDeleted = false order by date__c desc];
        
    }
    
    public PageReference caseDetail(){
        PageReference pr = Page.CaseDetail;
        pr.setRedirect(true);
        pr.getParameters().put('cid',this.getParameters().get('cid'));
        return pr;
    }
    
    public PageReference closeCase(){
        Case c = [select Id,isClosed from Case where Id =: getParameters().get('cid')];
        c.Status = 'Closed';
        c.Reason = 'Closed By Student';
        update c;
        
        return new PageReference('/apex/CaseView?sid=' + params.get('sid'));
    }
    
    public PageReference prEdit(){
        String pid = this.getParameters().get('pid');
        return new PageReference('/apex/ProgressReport?sid='+params.get('sid')+'&status=edit&pid='+pid);
    }
    
    public PageReference prDelete(){
        String pid = this.getParameters().get('pid');
        Progress_Report__c pr = [select Id,Name from Progress_Report__c where Id =: pid];
        delete pr;
        
        PageReference page = new PageReference('/apex/CaseView?sid=' + params.get('sid'));
        page.setRedirect(true);
        return page;
    }
    
    public PageReference vrNoteUpdate(){
        String vid = this.getParameters().get('vid');
        return new PageReference('/apex/VRNote?sid='+params.get('sid')+'&status=edit&vid='+vid);
    }
    
    public PageReference vrNoteDelete(){
        String vid = this.getParameters().get('vid');
        Vice_Rector_Note__c vr = [select Id,Name from Vice_Rector_Note__c where Id =: vid];
        delete vr;
        
        PageReference page = new PageReference('/apex/CaseView?sid=' + params.get('sid'));
        page.setRedirect(true);
        return page;
    }
}