trigger CapstoneModuleTrigger on Capstone_Module__c (after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
        	for(Capstone_Module__c project : Trigger.New){
                Id capstoneRecordTypeId = [select Id from RecordType where Name = 'Capstone Module'].Id;
                Case c = [select Id,Level_1_Approver__c,Level_2_Approver__c,ContactId,Level_1_Approver_Email__c from Case where Id =: project.Case__c];
                
                if(c.RecordTypeId == capstoneRecordTypeId && String.isNotEmpty(c.Level_1_Approver__c)){
                    CaseHelper.sendCapstoneApprovalNotification(c, '1');
                }
            }   
        }
    }
}