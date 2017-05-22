/**
 * Created by gian on 16/05/17.
 */
public class StudentLandingController extends CommunityControllerBase{

	public List<SelectOption> departments {set; get;}
	public List<SelectOption> subdepartments {set; get;}
	public List<SelectOption> typeOfEnquiries {set; get;}

	public String department {set; get;}
	public String subdepartment {set; get;}
	public String typeOfEnquiry {set; get;}

	public StudentLandingController(){
		departments = new List<SelectOption>();
		subdepartments = new List<SelectOption>();
		typeOfEnquiries = new List<SelectOption>();

		List<Department__c> ds = [select Id,Name from Department__c where Parent_Department__c = null order by Name];
		List<Department__c> sds = [select Id,Name from Department__c where Parent_Department__c != null order by Name];
		List<Type_of_Enquiry__c> ts = [select Id,Name,Link__c from Type_of_Enquiry__c where Department__c =: subdepartment];


		for(Department__c d : ds){
			departments.add(new SelectOption(d.Id, d.Name));
		}

		for(Department__c sd : sds){
			subdepartments.add(new SelectOption(sd.Id, sd.Name));
		}

		for(Type_of_Enquiry__c t : ts){
			typeOfEnquiries.add(new SelectOption(t.Id, t.Name));
		}
	}
}