// for test the page
// https://c.cs31.visual.force.com/apex/Case?sid=SID201609170000001&department=Student Services&subdepartment=Student Affairs&toe=Request for Transcripts
// type off enquiry picklist 

public class CaseController extends ControllerBase{
	
    public Case c {set; get;}
    public Attachment attachment {set; get;}
    public Contact contact {set;get;}
    public Department__c department {set;get;}
    
    private Map<String,String> params;

    public CaseController(){
        params = getParameters();
        
        contact = [select Id, Name, Student_Identity__c from Contact where Student_Identity__c =: params.get('sid')];
        
        c = new Case();
        c.ContactId = contact.Id;
        c.Department__c = params.get('department');
        c.Type_Of_Enquiry__c = params.get('toe');
        c.RecordTypeId = [select Id from RecordType where Name = 'Request for Transcripts'].Id;
        
        if(params.get('subdepartment') != 'null'){
        	c.Sub_Department__c = params.get('subdepartment');    
        }
        
        attachment = new Attachment();
    }
    
    public PageReference save(){
        PageReference result = null;
        
        try{
            c.Subject = c.Type_Of_Enquiry__c;
        	c.Status = 'Open';
            c.Origin = 'Web';
            c.Priority = 'High';
            
            insert c;
            
            if(attachment.Body != null){
            	attachment.ParentId = c.Id;
            	insert attachment;    
            }
            
            result = new PageReference('/apex/CaseResult?sid=' + params.get('sid') + '&cid=' + c.Id);
        }catch(Exception e){
            delete c;
            showErrorMessage('Case Saving Error : ' + e.getMessage());
        }finally{
            attachment.Body = null;
        }
        
        return result;
    }
    
    public PageReference cancel(){
        return new PageReference('/apex/GeneralEnquiry?sid='+contact.Student_Identity__c);
    }
}