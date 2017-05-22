public class LeadershipFundamentalsController extends CommunityControllerBase{

    public Contact contact {set; get;}
    public Case c {set; get;}
    public Leadership__c leadership {set; get;}
    
    private Map<String, String> params;
    
    public LeadershipFundamentalsController(){
        params = this.getParameters();
        
        contact = [select Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Current_Year__c,Length_of_Course__c,Major__c from Contact where Id =: ContactID];
        
        if(params.get('status') == 'new'){
            leadership = new Leadership__c();
            leadership.Full_Name__c = contact.Name;
            leadership.Email__c = contact.Email;
            leadership.Class_Year__c = contact.Current_Year__c;
            leadership.Type__c = params.get('toe');
            leadership.Status__c = 'In Progress';
            leadership.Contact__c = contact.Id;
            leadership.RecordTypeId = [select Id from RecordType where Name =: params.get('toe') and SobjectType = 'Leadership__c'].Id;
            
            c = new Case();
            c.ContactId = contact.Id;
            c.Department__c = params.get('department');
            c.Type_Of_Enquiry__c = params.get('toe');
            c.RecordTypeId = [select Id from RecordType where Name =: params.get('toe') and SobjectType = 'Case'].Id;
            
            if(params.get('subdepartment') != 'null'){
                c.Sub_Department__c = params.get('subdepartment');    
            }
            
            c.Subject = params.get('toe');
            c.Status = 'Open';
            c.Origin = 'Web';
            c.Priority = 'High';
        }else{
            leadership = [select Id,Name,Full_Name__c, Class_Year__c,Type__c,Status__c,Email__c,Description__c,Meaningful_Experience__c from Leadership__c where Id =: params.get('lid') ];
        }
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
    
    public PageReference save(){
        if(params.get('status') == 'new'){
            c.setOptions(dmo);
            insert c;
            
            leadership.Case__c = c.Id;
            insert leadership;
        }else{
            update leadership;
        }
        
        return redirectToCaseView();
    }
}