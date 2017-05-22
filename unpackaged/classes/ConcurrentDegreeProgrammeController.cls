public class ConcurrentDegreeProgrammeController extends CommunityControllerBase{
    public Concurrent_Degree_Programme__c cdp {set; get;}
    //public String today {set; get;}
    public Attachment gceAttachment {set; get;}
    public Attachment transacriptAttachment {set; get;}
    
    private Case c;
    private Contact contact;
    private Map<String, String> params;
    
    public ConcurrentDegreeProgrammeController(){
        params = this.getParameters();
        
        contact = [select Id,Student_Identity__c,Name,Gender__c,Phone,MobilePhone,Email,Birthdate from Contact where Id =: ContactID];
        
        if(params.get('status') == 'new'){
            //today = Datetime.now().format('dd MMMM yyyy');
            
            cdp = new Concurrent_Degree_Programme__c();
            cdp.Full_Name__c = contact.Name;
            cdp.Matriculation__c = contact.Student_Identity__c;
            cdp.Date_of_Birth__c = contact.Birthdate;
            cdp.Gender__c = contact.Gender__c;
            cdp.Contact_Number__c = contact.Phone;
            cdp.Mobile_Number__c = contact.MobilePhone;
            cdp.Email__c = contact.Email;
            cdp.Date__c = System.today();
            cdp.Contact__c = contact.Id;
            
            c = new Case();
            c.ContactId = contact.Id;
            c.Department__c = params.get('department');
            c.Type_Of_Enquiry__c = params.get('toe');
            c.RecordTypeId = [select Id from RecordType where Name =: params.get('toe')].Id;
            if(params.get('subdepartment') != 'null'){
                c.Sub_Department__c = params.get('subdepartment');    
            }            
        }else{
            //cdp = [select Id,Name,Case__c,Contact__c,Date__c,Exchange_Programme_Semesters__c,Full_Name__c,Matriculation__c,Citizenship__c,Gender__c,Contact_Number__c,Mobile_Number__c,Email__c,Exchange_Programme__c,Degree_Programme__c,Programme_Name__c,Special_Programmes__c,Special_Programme_Name__c,First_Answer__c,Second_Answer__c,Third_Answer__c,Education__c,Awards__c,Accomplishments__c,Volunteer_Work__c,Other_Information__c from Concurrent_Degree_Programme__c where Id =: params.get('cid')];
            
            Datetime dt = datetime.newInstance(cdp.Date__c.Year(), cdp.Date__c.Month(), cdp.Date__c.Day());
            //today = dt.format('dd MMMM yyyy');
        }

        gceAttachment = new Attachment();
        transacriptAttachment = new Attachment();
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
    
    public PageReference save(){
        if(params.get('status') == 'new'){
            c.Subject = params.get('toe');
            c.Status = 'Open';
            c.Origin = 'Web';
            c.Priority = 'High';
            c.setOptions(dmo);
            insert c;
            
            cdp.Case__c = c.Id;
            insert cdp;
            
            if(gceAttachment.Body != null){
                gceAttachment.ParentId = cdp.Id;
                gceAttachment.Name = 'GCE_' + gceAttachment.Name;
                insert gceAttachment;
                
                gceAttachment.Body = null;
            }
            
            if(transacriptAttachment.Body != null){
                transacriptAttachment.ParentId = cdp.Id;
                transacriptAttachment.Name = 'GCE_' + transacriptAttachment.Name;
                insert transacriptAttachment;
                
                transacriptAttachment.Body = null;
            }
        }else{
            update cdp;
        }
        
        return redirectToCaseView();
    }
}