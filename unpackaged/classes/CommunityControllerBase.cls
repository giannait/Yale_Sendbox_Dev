/**
 * Created by gian on 05/05/17.
 */
public virtual class CommunityControllerBase {

	public final Id ContactID {set; get;}
	public final String fileSizeMessage {set; get;}
	public final String fileSizeMessages {set; get;}
	public final Integer maxFileUploadSize {set; get;}
	public String formInformation {set; get;}
	public final String attachmentLabel {set; get;}
	public final Database.DMLOptions dmo;

	private Map<String, String> params;

	public CommunityControllerBase(){
		if(ContactID == null){
			User user = [select Id, ContactId from User where Id =: UserInfo.getUserId()];
			ContactID = user.ContactId;
		}

		params = getParameters();
		fileSizeMessage = '*Maximum upload file size is 5 Mbytes.';
		fileSizeMessages = '*Maximum upload file size is 5 Mbytes per file.';
		maxFileUploadSize = 5000000;
		attachmentLabel = 'Attachment File';

		// to set assignment rule and send email notification
		dmo = new Database.DMLOptions();
		dmo.assignmentRuleHeader.useDefaultRule = true;
		dmo.emailHeader.triggerUserEmail = true;
	}

	public PageReference onLoad(){
		Type_of_Enquiry__c toe = [
				select
				Id,Active__c
				from Type_of_Enquiry__c
				where Department__r.Name =: params.get('subdepartment') and
				Department__r.Parent_Department__r.Name =: params.get('department') and
				Name =: params.get('toe')
		];

		if(toe.Active__c){
			return null;
		}else{
			PageReference pr = new PageReference('/FileNotFound');
			pr.setRedirect(true);
			return pr;
		}
	}

	public PageReference redirectToCaseView(){
		PageReference pr = Page.CaseView;
		pr.setRedirect(true);
		return pr;
	}

	public Map<String,String> getParameters(){
		PageReference currentPage = ApexPages.currentPage();
		return currentPage.getParameters();
	}

	public void showWarningMessage(String message){
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, message));
	}

	public void showConfirmMessage(String message){
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, message));
	}

	public void showErrorMessage(String message){
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, message));
	}

}