public class SummerResearchController extends CommunityControllerBase{

    public Summer_Research__c sr {set; get;}
    public List<SR_Academic_Coursework__c> srac {set; get;}
    public String indexString {set; get;}
    
    private Case c;
    private Contact contact;
    private List<SR_Academic_Coursework__c> sracDeleted;
    private Map<String, String> params;
    
    public SummerResearchController(){
        params = this.getParameters();
        
        contact = [select Id,Name,Current_Year__c from Contact where Id =: ContactID];
        sracDeleted = new List<SR_Academic_Coursework__c>();
        
        if(params.get('status') == 'new'){
            sr = new Summer_Research__c();
            sr.Student_Name__c = contact.Name;
            sr.Class_Year__c = contact.Current_Year__c;
            sr.Date__c = System.today();
            sr.Contact__c = contact.Id;
            
            srac = new List<SR_Academic_Coursework__c>();
            srac.add(new SR_Academic_Coursework__c());
            
            c = new Case();
            c.ContactId = contact.Id;
            c.Department__c = params.get('department');
            c.Type_Of_Enquiry__c = params.get('toe');
            c.RecordTypeId = [select Id from RecordType where Name =: params.get('toe')].Id;
            if(params.get('subdepartment') != 'null'){
                c.Sub_Department__c = params.get('subdepartment');    
            }            
        }else{
            sr = [select Id,Name,Case__c,Contact__c,Date__c,Student_Name__c,Academic_Adviser__c,Class_Year__c,CAP__c,First_Choices__c,Second_Choices__c,Describe__c,First_Choices_Description__c,Second_Choices_Description__c,Special_Circumstances__c from Summer_Research__c where Id =: params.get('sid')];
            srac = [select Id,Name,Course__c,Institution__c,Dates_of_Study_Start__c,Dates_of_Study_End__c,Grade_Received__c from SR_Academic_Coursework__c where Summer_Research__c =: sr.Id];
            
            Datetime dt = datetime.newInstance(sr.Date__c.Year(), sr.Date__c.Month(), sr.Date__c.Day());
        }
    }
    
    public void addRow(){
        srac.add(new SR_Academic_Coursework__c());
    }
    
    public void deleteRow(){
        Integer index = Integer.valueOf(indexString) - 1;
        
        SR_Academic_Coursework__c dataDelete = srac.get(index);
        srac.remove(index);
        
        if(dataDelete.Summer_Research__c != null){
            sracDeleted.add(dataDelete);    
        }
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }

    public PageReference save(){
        List<SR_Academic_Coursework__c> sracInsert = new List<SR_Academic_Coursework__c>();
        
        if(params.get('status') == 'new'){
            c.Subject = params.get('toe');
            c.Status = 'Open';
            c.Origin = 'Web';
            c.Priority = 'High';
            c.setOptions(dmo);
            insert c;
            
            sr.Case__c = c.Id;
            sr.Status__c = 'In Progress';
            insert sr;
            
            for(SR_Academic_Coursework__c data : srac){
                if(String.isNotEmpty(data.Institution__c)){
                    data.Summer_Research__c = sr.Id;
                    sracInsert.add(data);
                }
            }
            
            insert srac;
        }else{
            update sr;
            
            List<SR_Academic_Coursework__c> sracUpdate = new List<SR_Academic_Coursework__c>();
            
            for(SR_Academic_Coursework__c data : srac){
                if(data.Summer_Research__c == null){
                    sracInsert.add(data);
                }else{
                    sracUpdate.add(data);
                }
            }
            
            insert sracInsert;
            update sracUpdate;
        }
        
        if(sracDeleted.size() >= 0){
            delete sracDeleted;
        }
        
        return redirectToCaseView();
    }
    
}