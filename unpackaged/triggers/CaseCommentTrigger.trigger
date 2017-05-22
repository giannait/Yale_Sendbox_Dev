trigger CaseCommentTrigger on CaseComment (before insert) {
	if(Trigger.isBefore){
		if(Trigger.isInsert){
			for(CaseComment comment : Trigger.new){
				comment.IsPublished = true;
			}
		}
	}
}