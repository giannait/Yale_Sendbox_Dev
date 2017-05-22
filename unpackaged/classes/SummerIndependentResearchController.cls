public class SummerIndependentResearchController extends CommunityControllerBase{

    public Summer_Independent_Research__c sir {set; get;}
    public List<SIR_Academic_Coursework__c> sirac {set; get;}
    //public String today {set;get;}
    public String indexString {set; get;}
    public Attachment budgetAttachment {set; get;}
    public Attachment transcriptAttachment {set; get;}
    public Attachment cvAttachment {set; get;}
    
    private Case c;
    private Contact contact;
    private List<SIR_Academic_Coursework__c> siracDeleted;
    private Map<String, String> params;
    
    public SummerIndependentResearchController(){
        params = this.getParameters();
        
        contact = [select Id,Name,Major__c,Graduation_Year__c from Contact where Id =: ContactID];
        siracDeleted = new List<SIR_Academic_Coursework__c>();
        
        budgetAttachment = new Attachment();
        transcriptAttachment = new Attachment();
        cvAttachment = new Attachment();
        
        if(params.get('status') == 'new'){
            //today = Datetime.now().format('dd MMMM yyyy');
            
            sir = new Summer_Independent_Research__c();
            sir.Full_Name__c = contact.Name;
            sir.Graduation_Year__c = contact.Graduation_Year__c;
            sir.Major__c = contact.Major__c;
            sir.Date__c = System.today();
            sir.Contact__c = contact.Id;
            
            sirac = new List<SIR_Academic_Coursework__c>();
            sirac.add(new SIR_Academic_Coursework__c());
            
            c = new Case();
            c.ContactId = contact.Id;
            c.Department__c = params.get('department');
            c.Type_Of_Enquiry__c = params.get('toe');
            c.RecordTypeId = [select Id from RecordType where Name =: params.get('toe')].Id;
            if(params.get('subdepartment') != 'null'){
                c.Sub_Department__c = params.get('subdepartment');    
            }            
        }else{
            sir = [select Id,Name,Case__c,Contact__c,Date__c,Full_Name__c,Graduation_Year__c,Major__c,CAP__c,Academic_Adviser__c,Project_Supervisor__c,Project_Supervisor_Email__c,Project_Co_Supervisor__c,Project_Co_Supervisor_Email__c,Project_Title__c,Background__c,Budget__c,Deliverables__c,Describe__c,Description__c,Location__c,Method__c,Potential_Hurdle__c,Project_Abstract__c,References__c,Research_Permit__c,Seeking_Answers__c,Special_Circumstances__c,Timeline__c,Hypothesis__c,Central_Research__c from Summer_Independent_Research__c where Id =: params.get('sid')];
            sirac = [select Id,Name,Course__c,Institution__c,Dates_of_Study_Start__c,Dates_of_Study_End__c,Grade_Received__c from SIR_Academic_Coursework__c where Summer_Independent_Research__c =: sir.Id];
            
            Datetime dt = datetime.newInstance(sir.Date__c.Year(), sir.Date__c.Month(), sir.Date__c.Day());
            //today = dt.format('dd MMMM yyyy');
        }
    }
    
    public void addRow(){
        sirac.add(new SIR_Academic_Coursework__c());
    }
    
    public void deleteRow(){
        Integer index = Integer.valueOf(indexString) - 1;
        
        SIR_Academic_Coursework__c dataDelete = sirac.get(index);
        sirac.remove(index);
        
        if(dataDelete.Summer_Independent_Research__c != null){
            siracDeleted.add(dataDelete);    
        }
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
    
    public PageReference save(){
        List<SIR_Academic_Coursework__c> siracInsert = new List<SIR_Academic_Coursework__c>();
        
        if(params.get('status') == 'new'){
            c.Subject = params.get('toe');
            c.Status = 'Open';
            c.Origin = 'Web';
            c.Priority = 'High';
            c.setOptions(dmo);
            insert c;
            
            sir.Status__c = 'In Progress';
            sir.Case__c = c.Id;
            insert sir;
            
            if(budgetAttachment.Body != null){
                budgetAttachment.ParentId = sir.Id;
                insert budgetAttachment;   
                budgetAttachment.Body = null;
            }
            
            if(transcriptAttachment.Body != null){
                transcriptAttachment.ParentId = sir.Id;
                insert transcriptAttachment;   
                transcriptAttachment.Body = null;
            }
            
            if(cvAttachment.Body != null){
                cvAttachment.ParentId = sir.Id;
                insert cvAttachment;   
                cvAttachment.Body = null;
            }
            
            for(SIR_Academic_Coursework__c data : sirac){
                if(String.isNotEmpty(data.Institution__c)){
                    data.Summer_Independent_Research__c = sir.Id;
                    siracInsert.add(data);
                }
            }
            
            insert sirac;
        }else{
            update sir;
            
            List<SIR_Academic_Coursework__c> siracUpdate = new List<SIR_Academic_Coursework__c>();
            
            for(SIR_Academic_Coursework__c data : sirac){
                if(data.Summer_Independent_Research__c == null){
                    siracInsert.add(data);
                }else{
                    siracUpdate.add(data);
                }
            }
            
            insert siracInsert;
            update siracUpdate;
        }
        
        if(siracDeleted.size() >= 0){
            delete siracDeleted;
        }

        return redirectToCaseView();
    }
}