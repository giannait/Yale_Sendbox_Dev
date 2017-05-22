public class ChangeOfMajorController extends CommunityControllerBase{
    
    public Contact contact {set; get;}
    public Case c {set; get;}
    public  Change_Of_Major__c com{set; get;}
    public List<Residential_College__c> rc {set; get;}
    public String residentialCollegeName {set; get;}
    //public String today {set; get;}
    public String currentMajor {set; get;}
    public String currentMinor {set; get;}
    public Boolean showMinor {set; get;}
    
    public List<SelectOption> hosMajorList {set; get;}
    public List<SelectOption> hosMinorList {set; get;}

    private Map<String, String> params;
    
    public ChangeOfMajorController(){
        params = this.getParameters();
        
        contact = [select Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Current_Year__c,Length_of_Course__c,Major__c,Minor__c from Contact where Id =: ContactID];
        rc = [select Id,Name,Date_To__c,Date_From__c,Suite_No__c,Residential_College_Master__r.Name from Residential_College__c where Contact__c =: contact.Id and Date_To__c = null limit 1];
        
        if(rc.size() > 0){
            residentialCollegeName = rc.get(0).Residential_College_Master__r.Name;
        }else{
            residentialCollegeName = '-';
        }

        if(params.get('status') == 'new'){
            //today = Datetime.now().format('dd MMMM yyyy');
            
            com = new Change_Of_Major__c();
            com.Date__c = System.today();
            com.Contact__c = contact.Id;
            com.Current_Major__c = contact.Major__c;
            com.Current_Minor__c = contact.Minor__c;
            
            currentMajor = com.Current_Major__c;
            currentMinor = com.Current_Minor__c;

            if(String.isNotEmpty(currentMinor)){
                showMinor = true;
            }else{
                showMinor = false;
            }
            
            c = new Case();
            c.ContactId = contact.Id;
            c.Department__c = params.get('department');
            c.Type_Of_Enquiry__c = params.get('toe');
            c.RecordTypeId = [select Id from RecordType where Name = 'Change of Major'].Id;
            if(params.get('subdepartment') != 'null'){
                c.Sub_Department__c = params.get('subdepartment');    
            }
            
            hosMajorList = new List<SelectOption>();
            hosMinorList = new List<SelectOption>();
            
            hosMajorList.add(new SelectOption('', '--None--'));
            hosMinorList.add(new SelectOption('', '--None--'));
            
            for(User user : [select Name from User where Type__c includes('Head of Study')]){
                hosMajorList.add(new SelectOption(user.Id, user.Name));
                hosMinorList.add(new SelectOption(user.Id, user.Name));
            }
        }else{
            com = [select Id,Name,Case__c,Contact__c,Current_Major__c,Current_Minor__c,New_Major__c,New_Minor__c,Change_Drop_Minor__c from Change_Of_Major__c where Id =: params.get('cid')];
            c = [select Id,ContactId,Department__c,Type_Of_Enquiry__c,RecordTypeId,Sub_Department__c,Subject,Status,Origin,Priority,Start_Date__c,End_Date__c from Case where Id =: com.Case__c];
            
            Datetime dt = datetime.newInstance(com.Date__c.Year(), com.Date__c.Month(), com.Date__c.Day());
            //today = dt.format('dd MMMM yyyy');
            
            currentMajor = com.Current_Major__c;
            currentMinor = com.Current_Minor__c;
        }
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
            
            com.Case__c = c.Id;
            
            if(String.isEmpty(com.Major_Head_Of_Study__c)){
                com.Major_Head_Of_Study__c = null;
            }
            
            if(String.isEmpty(com.Minor_Head_Of_Study__c)){
                com.Minor_Head_Of_Study__c = null;
            }
            
            insert com;
        }else{
            update com;
        }
        
        return redirectToCaseView();
    }

}