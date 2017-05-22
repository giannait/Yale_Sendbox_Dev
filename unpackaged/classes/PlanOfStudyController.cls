public class PlanOfStudyController extends CommunityControllerBase{

    public Contact contact {set; get;}
    public Plan_Of_Study__c pos {set; get;}
    public List<Plan_Of_Study_Detail__c> posd {set; get;}
    //public List<Plan_Of_Study_Result__c> posr {set; get;}
    public Plan_Of_Study_Result__c posResult {set; get;}
    public List<Residential_College__c> residentialColleges;
    public String residentialCollegeName {set; get;}
    //public String today {set; get;}
    public List<Vice_Rector_Note_Module__c> modules {set; get;}
    public String posdIndexString {set; get;}
    public String posrIndexString {set; get;}
    
    
    private Map<String, String> params;
    private List<Plan_Of_Study_Detail__c> posdDelete {set; get;}
    //private List<Plan_Of_Study_Result__c> posrDelete {set; get;}
    
    public PlanOfStudyController(){
        params = this.getParameters();
        
        contact = [select Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Current_Year__c,Length_of_Course__c,Major__c,NUSNET_ID__c from Contact where Id =: ContactID];
        residentialColleges = [select Id,Name,Date_To__c,Date_From__c,Suite_No__c,Residential_College_Master__r.Name from Residential_College__c where Contact__c =: contact.Id and Date_To__c = null limit 1];
        
        if(residentialColleges.size() > 0){
            residentialCollegeName = residentialColleges.get(0).Residential_College_Master__r.Name;
        }else{
            residentialCollegeName = '';
        }
        
        posdDelete = new List<Plan_Of_Study_Detail__c>();
        //posrDelete = new List<Plan_Of_Study_Result__c>();
        
        if(params.get('status') == 'new'){
            //today = Datetime.now().format('dd MMMM yyyy');
            
            pos = new Plan_Of_Study__c();
            pos.Date__c = System.today();
            pos.Contact__c = contact.Id;
            pos.Year_Of_Study__c = contact.Current_Year__c;
            
            checkPOSData(contact.Id, contact.Current_Year__c);
        }else{
            pos = [select Id,Name,Contact__c,Date__c,Year_Of_Study__c,Faculty_Advisor__c,Head_of_Studies__c,Capstone_Advisor__c from Plan_Of_Study__c where Id =: params.get('pid')];
            posd = [select Id,Name,Semester__c,Module_Name__c,MC__c,Major_Request__c,Extra_curricular__c,Plan_Of_Study__c From Plan_Of_Study_Detail__c where Plan_Of_Study__c =: pos.Id];
            List<Plan_Of_Study_Result__c> posr = [select Id,Name,MC__c,CAP__c,Task__c,Programme__c,Career_Planning__c,Reflection__c,Plan_Of_Study__c From Plan_Of_Study_Result__c where Plan_Of_Study__c =: pos.Id];
            posResult = posr.get(0);
            
            Datetime dt = datetime.newInstance(pos.Date__c.Year(), pos.Date__c.Month(), pos.Date__c.Day());
            //today = dt.format('dd MMMM yyyy');
        }
    }
    
    private void checkPOSData(String contactId, String yearOfStudy){
        List<Plan_Of_Study__c> checkPOS = [select Id,Name,Contact__c,Date__c,Year_Of_Study__c,Faculty_Advisor__c,Head_of_Studies__c,Capstone_Advisor__c from Plan_Of_Study__c where Contact__c =: contactId and Year_Of_Study__c =: yearOfStudy];
        
        if(checkPOS.size() > 0){
            pos = checkPOS.get(0);
            
            posd = [select Id,Name,Semester__c,Module_Name__c,MC__c,Major_Request__c,Extra_curricular__c,Plan_Of_Study__c From Plan_Of_Study_Detail__c where Plan_Of_Study__c =: pos.Id and isDeleted__c = false];
            List<Plan_Of_Study_Result__c> posr = [select Id,Name,MC__c,CAP__c,Task__c,Programme__c,Career_Planning__c,Reflection__c,Plan_Of_Study__c From Plan_Of_Study_Result__c where Plan_Of_Study__c =: pos.Id and isDeleted__c = false];
            posResult = posr.get(0);
        }else{
            //today = Datetime.now().format('dd MMMM yyyy');
            
            pos = new Plan_Of_Study__c();
            pos.Date__c = System.today();
            pos.Contact__c = contact.Id;
            pos.Year_Of_Study__c = yearOfStudy;
            
            posd = new List<Plan_Of_Study_Detail__c>();
            posd.add(new Plan_Of_Study_Detail__c());
            
            //posr = new List<Plan_Of_Study_Result__c>();
            //posr.add(new Plan_Of_Study_Result__c());
            
            posResult = new Plan_Of_Study_Result__c();
        }
    }
    
    public void yearOfStudyOnChange(){
        checkPOSData(contact.Id, pos.Year_Of_Study__c);
    }
    
    public void posdAddRow(){
        posd.add(new Plan_Of_Study_Detail__c());
    }
    
    public void posdDeleteRow(){
        Integer index = Integer.valueOf(posdIndexString) - 1;
        
        Plan_Of_Study_Detail__c data = posd.get(index);
        posd.remove(index);
        
        if(String.isNotEmpty(data.Plan_Of_Study__c)){
            data.isDeleted__c = true;
            posdDelete.add(data);
        }
    }
    
    /*
    public void posrAddRow(){
        posr.add(new Plan_Of_Study_Result__c());
    }
    
    public void posrDeleteRow(){
        Integer index = Integer.valueOf(posrIndexString) - 1;
        
        Plan_Of_Study_Result__c data = posr.get(index);
        posr.remove(index);
        
        if(String.isNotEmpty(data.Plan_Of_Study__c)){
            data.isDeleted__c = true;
            posrDelete.add(data);
        }
    }
    */

    public PageReference save(){
        List<Plan_Of_Study_Detail__c> posdInsert = new List<Plan_Of_Study_Detail__c>();
        //List<Plan_Of_Study_result__c> posrInsert = new List<Plan_Of_Study_result__c>();
        
        List<Plan_Of_Study_Detail__c> posdUpdate = new List<Plan_Of_Study_Detail__c>();
        //List<Plan_Of_Study_result__c> posrUpdate = new List<Plan_Of_Study_result__c>();
        
        if(params.get('status') == 'new'){
            if(String.isNotEmpty(pos.Id)){
                update pos;    
            }else{
                insert pos;
            }
            
            for(Plan_Of_Study_Detail__c data : posd){
                if(String.isNotEmpty(data.Module_Name__c)){
                    if(String.isNotEmpty(data.Id)){
                        posdUpdate.add(data);   
                    }else{
                        data.Plan_Of_Study__c = pos.Id;
                        posdInsert.add(data);    
                    }
                }
            }
            
            /*
            for(Plan_Of_Study_Result__c data : posr){
                if(String.isNotEmpty(data.MC__c)){
                    if(String.isNotEmpty(data.Id)){
                        posrUpdate.add(data);   
                    }else{
                        data.Plan_Of_Study__c = pos.Id;
                        posrInsert.add(data);    
                    }
                }
            }
			*/
            
            if(String.isNotEmpty(posResult.MC__c)){
                if(String.isNotEmpty(posResult.Id)){
                    update posResult;
                }else{
                    posResult.Plan_Of_Study__c = pos.Id;
                    insert posResult;
                }
           	}            

            insert posdInsert;
            //insert posrInsert;
            
            update posdUpdate;
            //update posrUpdate;
        }else{
            update pos;
            
            for(Plan_Of_Study_Detail__c data : posd){
                if(String.isNotEmpty(data.Plan_Of_Study__c)){
                    posdUpdate.add(data);
                }else{
                    if(String.isNotEmpty(data.Module_Name__c)){
                        data.Plan_Of_Study__c = pos.Id;
                        posdInsert.add(data);
                    }
                }
            }
            
            /*
            for(Plan_Of_Study_Result__c data : posr){
                if(String.isNotEmpty(data.Plan_Of_Study__c)){
                    posrUpdate.add(data);
                }else{
                    if(String.isNotEmpty(data.MC__c)){
                        data.Plan_Of_Study__c = pos.Id;
                        posrInsert.add(data);
                    }    
                }
            }
            */
            
            if(String.isNotEmpty(posResult.Plan_Of_Study__c)){
                update posResult;
            }else{
                if(String.isNotEmpty(posResult.MC__c)){
                    posResult.Plan_Of_Study__c = pos.Id;
                    insert posResult;
               	}
            }
            
            insert posdInsert;
            //insert posrInsert;
            
            update posdUpdate;
            //update posrUpdate;
        }
        
        if(posdDelete.size() > 0){
            update posdDelete;
        }
        
        /*
        if(posrDelete.size() > 0){
            update posrDelete;
        }
        */
        
        return cancel();
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
}