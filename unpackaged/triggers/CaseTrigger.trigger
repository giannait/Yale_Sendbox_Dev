trigger CaseTrigger on Case (after update, before insert, before update) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            CaseHelper.caseAfterUpdate(Trigger.new, Trigger.oldMap);
            /*
            String recordTypeName;
            for(Case c : Trigger.new){
                recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(c.recordtypeid).getname();
                if(recordtypename == 'REC Form Submission'){
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setComments('Submitted for approval. Please approve.');
                    req.setObjectId(c.Id);
                    Approval.process(req);
                }
            }
            */
        }
    }
    
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            CaseHelper.setTimeApprovalReminder(Trigger.New);
        }
    }
}