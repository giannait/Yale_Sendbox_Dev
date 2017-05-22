public class CapstoneModuleApprovalController extends ControllerBase{
    
    public Capstone_Module__c project {set; get;}
    public Contact approver {set; get;}
    public Contact student {set; get;}
    public Case c {set;get;}
    public Boolean firstApproval {set; get;}
    
    public Boolean approvalProcess {set; get;}
    
    private Map<String,String> params;
    private String caseID;
    
    
    public CapstoneModuleApprovalController(){
        params = this.getParameters();
        approvalProcess = true;
        
        try{
            project = [select Id,Case__c,Project_Title__c,Project_Description__c,Supervision__c from Capstone_Module__c where Id =: params.get('id')];
            
            if(params.get('level') == '1'){
                c = [select 
                        Id,ContactId,Level_1_Approver__c,Level_1_Approver_Email__c,Level_1_Approver_Status__c,
                        Level_1_Approver_Comments__c,Capstone_Approval_Status__c,OwnerId,CaseNumber 
                    from Case 
                    where Id =: project.Case__c];
                
                firstApproval = true;
            }else{
                c = [
                    select 
                        Id,ContactId,Level_2_Approver__c,Level_2_Approver_Email__c,Level_2_Approver_Status__c,Level_2_Approver_Comments__c,
                        Level_1_Approver__c,Level_1_Approver_Status__c,Level_1_Approver_Comments__c,Capstone_Approval_Status__c,OwnerId,CaseNumber
                    from Case 
                    where Id =: project.Case__c
                ];
                
                approver = [select Name from Contact where Id =: c.Level_2_Approver__c ];
                firstApproval = false;
            }
            
            student = [select Name,Student_Identity__c,Email,Current_Year__c,Major__c from Contact where Id =: c.ContactId];
            
            caseID = c.Id;
            c.Id = null;
        }catch(Exception e){
            this.showErrorMessage(e.getMessage());
        }
    }
    
    private Boolean secondLevelApproval(){
        Case cs = [select Id,Level_2_Approver_Email__c from Case where Id =: project.Case__c];
        
        if(String.isNotEmpty(cs.Level_2_Approver_Email__c)){
            return true;
        }
        
        return false;
    }
    
    public PageReference checkApproval(){
        if(params.get('level') == '1'){
            if(c.Level_1_Approver_Status__c == 'Reject' || c.Level_1_Approver_Status__c == 'Approve'){
                this.showErrorMessage('You already ' + c.Level_1_Approver_Status__c + ' this Capstone Project Proposal'); 
                approvalProcess = false;
            }
        }else{
            if(c.Level_2_Approver_Status__c == 'Reject' || c.Level_2_Approver_Status__c == 'Approve'){
                this.showErrorMessage('You already ' + c.Level_1_Approver_Status__c + ' this Capstone Project Proposal');
                approvalProcess = false;
            }
        }
        
        return null;
    }
    
    public PageReference process(){
        // update c;
        
        if(params.get('level') == '1'){
            if(secondLevelApproval()){
                this.showConfirmMessage('Thank you for the confirmation, this submission is being routed to the next approver.');
                if(c.Level_1_Approver_Status__c == 'Approve'){
                    c.Capstone_Approval_Status__c = 'Second Level Approval';    
                }
            }else{
                this.showConfirmMessage('Thank you for the confirmation.');
                if(c.Level_1_Approver_Status__c == 'Approve'){
                    c.Capstone_Approval_Status__c = 'Final Approval';    
                }
            }
        }else{
            this.showConfirmMessage('Thank you for the confirmation.');
            
            if(c.Level_2_Approver_Status__c == 'Approve'){
                c.Capstone_Approval_Status__c = 'Final Approval';
            }else{
                CaseHelper.sendCapstoneRejectedApprovalNotification(c, approver.Name, c.Level_2_Approver_Email__c, c.Level_2_Approver_Comments__c, 'owner');
                CaseHelper.sendCapstoneRejectedApprovalNotification(c, approver.Name, c.Level_2_Approver_Email__c, c.Level_2_Approver_Comments__c, 'student');
            }
        }
        
        // update c;
        approvalProcess = false;
        
        CaseHelper.updateApprovalCase(params.get('level'), caseID, c.Level_1_Approver_Status__c, c.Level_1_Approver_Comments__c, c.Level_2_Approver_Status__c, c.Level_2_Approver_Comments__c, c.Capstone_Approval_Status__c);
        
        //if(c.Capstone_Approval_Status__c == 'Final Approval'){
        //    System.debug('owner Id : ' + c.OwnerId);
        //  User user = [select Id from User where Id =: c.OwnerId];
        //    
        //    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        //    req.setComments('Submitted for approval. Please approve.');
        //    req.setObjectId(caseID);
        //    Approval.ProcessResult result = Approval.process(req);    
        //}
        
        return null;
    }
}