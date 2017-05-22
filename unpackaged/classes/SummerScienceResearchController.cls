public class SummerScienceResearchController extends CommunityControllerBase{
    
    public Summer_Science_Research__c ssr {set; get;}
    public List<SSR_Academic_Coursework__c> ssrac {set; get;}
    //public String today {set;get;}
    public String indexString {set; get;}
    
    private Case c;
    private Contact contact;
    private List<SSR_Academic_Coursework__c> ssracDeleted;
    private Map<String, String> params;
    
    public SummerScienceResearchController(){
        params = this.getParameters();
        
        contact = [select Id,Name,Current_Year__c from Contact where Id =: ContactID];
        ssracDeleted = new List<SSR_Academic_Coursework__c>();
        
        if(params.get('status') == 'new'){
            //today = Datetime.now().format('dd MMMM yyyy');
            
            ssr = new Summer_Science_Research__c();
            ssr.Student_Name__c = contact.Name;
            ssr.Class_Year__c = contact.Current_Year__c;
            ssr.Date__c = System.today();
            ssr.Contact__c = contact.Id;
            
            ssrac = new List<SSR_Academic_Coursework__c>();
            ssrac.add(new SSR_Academic_Coursework__c());
            
            c = new Case();
            c.ContactId = contact.Id;
            c.Department__c = params.get('department');
            c.Type_Of_Enquiry__c = params.get('toe');
            c.RecordTypeId = [select Id from RecordType where Name =: params.get('toe')].Id;
            if(params.get('subdepartment') != 'null'){
                c.Sub_Department__c = params.get('subdepartment');    
            }            
        }else{
            ssr = [select Id,Name,Case__c,Contact__c,Date__c,Student_Name__c,Academic_Adviser__c,Class_Year__c,CAP__c,First_Choices__c,Second_Choices__c,Describe__c,First_Choices_Description__c,Second_Choices_Description__c,Special_Circumstances__c from Summer_Science_Research__c where Id =: params.get('sid')];
            ssrac = [select Id,Name,Course__c,Institution__c,Dates_of_Study_Start__c,Dates_of_Study_End__c,Grade_Received__c from SSR_Academic_Coursework__c where Summer_Science_Research__c =: ssr.Id];
            
            Datetime dt = datetime.newInstance(ssr.Date__c.Year(), ssr.Date__c.Month(), ssr.Date__c.Day());
            //today = dt.format('dd MMMM yyyy');
        }
    }
    
    public void addRow(){
        ssrac.add(new SSR_Academic_Coursework__c());
    }
    
    public void deleteRow(){
        Integer index = Integer.valueOf(indexString) - 1;
        
        SSR_Academic_Coursework__c dataDelete = ssrac.get(index);
        ssrac.remove(index);
        
        if(dataDelete.Summer_Science_Research__c != null){
            ssracDeleted.add(dataDelete);    
        }
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
    
    public PageReference save(){
        List<SSR_Academic_Coursework__c> ssracInsert = new List<SSR_Academic_Coursework__c>();
        
        if(params.get('status') == 'new'){
            c.Subject = params.get('toe');
            c.Status = 'Open';
            c.Origin = 'Web';
            c.Priority = 'High';
            c.setOptions(dmo);
            insert c;
            
            ssr.Case__c = c.Id;
            ssr.Status__c = 'In Progress';
            insert ssr;
            
            for(SSR_Academic_Coursework__c data : ssrac){
                if(String.isNotEmpty(data.Institution__c)){
                    data.Summer_Science_Research__c = ssr.Id;
                    ssracInsert.add(data);
                }
            }
            
            insert ssrac;
        }else{
            update ssr;
            
            List<SSR_Academic_Coursework__c> ssracUpdate = new List<SSR_Academic_Coursework__c>();
            
            for(SSR_Academic_Coursework__c data : ssrac){
                if(data.Summer_Science_Research__c == null){
                    ssracInsert.add(data);
                }else{
                    ssracUpdate.add(data);
                }
            }
            
            insert ssracInsert;
            update ssracUpdate;
        }
        
        if(ssracDeleted.size() >= 0){
            delete ssracDeleted;
        }
        
        return redirectToCaseView();
    }
}