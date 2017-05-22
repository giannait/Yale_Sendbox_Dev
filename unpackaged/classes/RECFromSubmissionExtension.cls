/**
 * Created by gian on 25/04/17.
 */
public class RECFromSubmissionExtension{

	public REC_Form_Submitted__c rec {set; get;}

	public RECFromSubmissionExtension(ApexPages.StandardController stdController){
		rec = (REC_Form_Submitted__c)stdController.getRecord();
	}
}