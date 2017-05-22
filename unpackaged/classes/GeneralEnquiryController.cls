public class GeneralEnquiryController extends CommunityControllerBase{

    public List<Department__c> departments {set; get;}
    public List<Department__c> subDepartments {set; get;}
    public List<Type_of_Enquiry__c> toes {set; get;}
    
    public Contact contact {set; get;}
    
    public boolean showDepartment {set; get;}
    public boolean showSubDepartment {set; get;}
    public boolean showTypeOfEnquiry {set; get;}
    
    public String department {set; get;}
    public String subDepartment {set; get;}
    public String typeOfEnquiry {set; get;}
    
    public GeneralEnquiryController(){
        Map<String, String> params = getParameters();
        
        contact = [select Id,Name,Student_Identity__c,NUSNET_ID__c from Contact where Id =: ContactID];
        departments = [select Id,Name,Description__c from Department__c where Parent_Department__c = null and Active__c = true order by Name];
        toes = [select Id,Name,Link__c from Type_of_Enquiry__c];
        
        showDepartment = true;
        showSubDepartment = false;
        showTypeOfEnquiry = false;
    }
    
    public PageReference back(){
        return redirectToCaseView();
    }
    
    public void pickDepartment(){
        department = getParameters().get('department');
        
        subDepartments = [select Id,Name,Description__c from Department__c where Parent_Department__r.Name =: department and Active__c = true order by Name];
        
        showDepartment = false;
        showSubDepartment = true;
        showTypeOfEnquiry = false;
    }
    
    public void pickSubDepartment(){
        subDepartment = getParameters().get('subDepartment');
        
        System.debug('sd = ' +subDepartment);
        
        Department__c d = [select Id from Department__c where Name =: subDepartment order by Name];
        toes = [select Id,Name,Link__c from Type_of_Enquiry__c where Department__c =: d.Id and Active__c = true];
        
        showDepartment = false;
        showSubDepartment = false;
        showTypeOfEnquiry = true;
    }
    
    public void prevSubDepartment(){
        department = '';
        
        showDepartment = true;
        showSubDepartment = false;
        showTypeOfEnquiry = false;
    }
    
    public void prevTypeOfEnquiry(){
        subDepartment = '';
        
        showDepartment = false;
        showSubDepartment = true;
        showTypeOfEnquiry = false;
    }
}