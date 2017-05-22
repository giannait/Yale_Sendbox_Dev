public class ProgressReportController extends CommunityControllerBase{

    public Contact contact {set; get;}
    public Progress_Report__c progressReport {set; get;}
    public List<SelectOption> supervisorList {set; get;}
//    public String department {set; get;}
//    public String subDepartment {set; get;}
//    public String typeOfEnquiry {set; get;}
    
    private Map<String, String> params;
    
    public ProgressReportController(){
        params = this.getParameters();
        
        contact = [select Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Current_Year__c,Length_of_Course__c,Major__c,Semester__c,NUSNET_ID__c from Contact where Id =: ContactID];
        supervisorList = new List<SelectOption>();
        
        List<User> supervisorUsers = [select Name from User where Type__c includes('Supervisor')];
        for(User supervisorUser : supervisorUsers){
            supervisorList.add(new SelectOption(supervisorUser.Name, supervisorUser.Name));
        }

        if(params.get('status') == 'new'){
            progressReport = new Progress_Report__c();
            progressReport.Student__c = contact.Id;
            progressReport.Date__c = System.today();
            progressReport.Department__c = params.get('department');
            progressReport.Sub_Department__c = params.get('subdepartment');
            progressReport.Year_of_Study__c = contact.Current_Year__c;
            progressReport.Semester__c = contact.Semester__c;
            
//            checkProgressReportData(contact.Id, contact.Current_Year__c, contact.Semester__c);
        }else{
            progressReport = [select Id,Student__c,Academic_Advising__c,Semester__c,Year_of_Study__c,Head_of_Study__c,Capstone_Advisor__c,Faculty_Advisor__c from Progress_Report__c where Id =: params.get('pid')];
        }
    }
    
    private void checkProgressReportData(String contactId, String yearOfStudy, String semester){
        List<Progress_Report__c> pr = [select Id,Student__c,Academic_Advising__c,Semester__c,Year_of_Study__c,Head_of_Study__c,Capstone_Advisor__c,Faculty_Advisor__c from Progress_Report__c where Student__c =: contactId and Year_Of_Study__c =: yearOfStudy and Semester__c =: semester];
        
        if(pr.size() > 0){
            progressReport = pr.get(0);
        }else{
            progressReport = new Progress_Report__c();
            progressReport.Student__c = contact.Id;
            progressReport.Date__c = System.today();
            progressReport.Department__c = params.get('department');
            progressReport.Sub_Department__c = params.get('subdepartment');
            progressReport.Year_of_Study__c = yearOfStudy;
            progressReport.Semester__c = semester;
        }
    }
    
    public void yearOfStudyOnChange(){
//        checkProgressReportData(contact.Id, progressReport.Year_of_Study__c, progressReport.Semester__c);
    }
    
    public PageReference save(){
        if(String.isEmpty(progressReport.Year_of_Study__c)){
            this.showErrorMessage('Year of Study cannot be empty!');
            return null;
        }
        
        /*
        if(String.isEmpty(progressReport.Academic_Advising__c)){
            this.showErrorMessage('Academic Advising cannot be empty!');
            return null;
        }
		*/
        
        if(String.isEmpty(progressReport.Faculty_Advisor__c)){
            this.showErrorMessage('Faculty Advisor cannot be empty!');
            return null;
        }
        
        if(params.get('status') == 'new'){
            if(String.isNotEmpty(progressReport.Id)){
                update progressReport;    
            }else{
                insert progressReport;
            }
            
        }else{
            update progressReport;
        }
        
        return cancel();
    }
    
    public PageReference cancel(){
        return redirectToCaseView();
    }
}