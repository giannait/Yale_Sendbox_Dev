public class SummerSocialScienceResearchController extends CommunityControllerBase{
    
    public Summer_Social_Science_Research__c sssr {set; get;}
    public List<SSSR_Academic_Coursework__c> sssrac {set; get;}
    //public String today {set;get;}
    public String indexString {set; get;}
    
    private Case c;
    private Contact contact;
    private List<SSSR_Academic_Coursework__c> sssracDeleted;
    private Map<String, String> params;
    
    public SummerSocialScienceResearchController(){
        params = this.getParameters();
        
        contact = [select Id,Name,Current_Year__c from Contact where Id =: ContactID];
        sssracDeleted = new List<SSSR_Academic_Coursework__c>();
        
        if(params.get('status') == 'new'){
            //today = Datetime.now().format('dd MMMM yyyy');
            
            sssr = new Summer_Social_Science_Research__c();
            sssr.Full_Name__c = contact.Name;
            sssr.Class_Year__c = contact.Current_Year__c;
            sssr.Date__c = System.today();
            sssr.Contact__c = contact.Id;
            
            sssrac = new List<SSSR_Academic_Coursework__c>();
            sssrac.add(new SSSR_Academic_Coursework__c());
            
            c = new Case();
            c.ContactId = contact.Id;
            c.Department__c = params.get('department');
            c.Type_Of_Enquiry__c = params.get('toe');
            c.RecordTypeId = [select Id from RecordType where Name =: params.get('toe')].Id;
            if(params.get('subdepartment') != 'null'){
                c.Sub_Department__c = params.get('subdepartment');    
            }            
        }else{
            sssr = [select Id,Name,Case__c,Contact__c,Date__c,Full_Name__c,Academic_Adviser__c,Class_Year__c,CAP__c,First_Choices__c,Second_Choices__c,Describe__c,First_Choices_Description__c,Second_Choices_Description__c,Special_Circumstances__c from Summer_Social_Science_Research__c where Id =: params.get('sid')];
            sssrac = [select Id,Name,Course__c,Institution__c,Dates_of_Study_Start__c,Dates_of_Study_End__c,Grade_Received__c from SSSR_Academic_Coursework__c where Summer_Social_Science_Research__c =: sssr.Id];
            
            Datetime dt = datetime.newInstance(sssr.Date__c.Year(), sssr.Date__c.Month(), sssr.Date__c.Day());
            //today = dt.format('dd MMMM yyyy');
        }        
    }
    
    public void addRow(){
        sssrac.add(new SSSR_Academic_Coursework__c());
    }
    
    public void deleteRow(){
        Integer index = Integer.valueOf(indexString) - 1;
        
        SSSR_Academic_Coursework__c dataDelete = sssrac.get(index);
        sssrac.remove(index);
        
        if(dataDelete.Summer_Social_Science_Research__c != null){
            sssracDeleted.add(dataDelete);    
        }
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
    
    public PageReference save(){
        List<SSSR_Academic_Coursework__c> sssracInsert = new List<SSSR_Academic_Coursework__c>();
        
        if(params.get('status') == 'new'){
            c.Subject = params.get('toe');
            c.Status = 'Open';
            c.Origin = 'Web';
            c.Priority = 'High';
            c.setOptions(dmo);
            insert c;
            
            sssr.Status__c = 'In Progress';
            sssr.Case__c = c.Id;
            insert sssr;
            
            for(SSSR_Academic_Coursework__c data : sssrac){
                if(String.isNotEmpty(data.Institution__c)){
                    data.Summer_Social_Science_Research__c = sssr.Id;
                    sssracInsert.add(data);
                }
            }
            
            insert sssrac;
        }else{
            update sssr;
            
            List<SSSR_Academic_Coursework__c> sssracUpdate = new List<SSSR_Academic_Coursework__c>();
            
            for(SSSR_Academic_Coursework__c data : sssrac){
                if(data.Summer_Social_Science_Research__c == null){
                    sssracInsert.add(data);
                }else{
                    sssracUpdate.add(data);
                }
            }
            
            insert sssracInsert;
            update sssracUpdate;
        }
        
        if(sssracDeleted.size() >= 0){
            delete sssracDeleted;
        }
        
        return redirectToCaseView();
    }
}