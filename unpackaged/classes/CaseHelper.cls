global class CaseHelper {
    public static void caseAfterUpdate(List<Case> newCases, Map<Id, Case> oldCases){
        Id capstoneRecordTypeId = [select Id from RecordType where Name = 'Capstone Module'].Id;
        Id recRecordTypeId = [select Id from RecordType where Name = 'REC Form Submission'].Id;

        Set<Id> caseIds = new Set<Id>();
        for(Case c : newCases){
            caseIds.add(c.Id);
        }

        List<Attachment> certificates = [select Id,Name,Body,ParentId from Attachment where Name like 'Certificate%' and ParentId in: caseIds order by CreatedDate desc LIMIT 1000];
        List<Attachment> rescue = [select Id,Name,Body,ParentId from Attachment where Name like 'RESCUE%' and ParentId in: caseIds order by CreatedDate desc LIMIT 1000];
        List<Attachment> chser = [select Id,Name,Body,ParentId from Attachment where Name like 'CHSER%' and ParentId in: caseIds order by CreatedDate desc LIMIT 1000];
        List<Attachment> pis = [select Id,Name,Body,ParentId from Attachment where Name like 'PIS%' and ParentId in: caseIds order by CreatedDate desc LIMIT 1000];
        List<Attachment> icf = [select Id,Name,Body,ParentId from Attachment where Name like 'ICF%' and ParentId in: caseIds order by CreatedDate desc LIMIT 1000];
        List<Attachment> fsp = [select Id,Name,Body,ParentId from Attachment where Name like 'FSP%' and ParentId in: caseIds order by CreatedDate desc LIMIT 1000];

        Map<String, Case> cases = new Map<String, Case>([
                select
                Id, (select Id from REC_Form_Submitted__r)
                from Case
                Where Id IN: caseIds
        ]);

        List<Attachment> attachments = new List<Attachment>();

        for(Case c : newCases){
            Case oldCase = oldCases.get(c.Id);

            if(c.RecordTypeId == capstoneRecordTypeId){
                if(c.Level_1_Approver_Status__c != oldCase.Level_1_Approver_Status__c && c.Level_1_Approver_Status__c == 'Approve'){
                    if(String.isNotEmpty(c.Level_2_Approver__c) && String.isNotEmpty(c.Level_2_Approver_Email__c)){
                        CaseHelper.sendCapstoneApprovalNotification(c, '2');
                    }
                }else if(c.Level_1_Approver_Status__c != oldCase.Level_1_Approver_Status__c && c.Level_1_Approver_Status__c == 'Reject'){
                    CaseHelper.sendCapstoneRejectedApprovalNotification(c, c.Level_1_Approver__c, c.Level_1_Approver_Email__c, c.Level_1_Approver_Comments__c, 'owner');
                    CaseHelper.sendCapstoneRejectedApprovalNotification(c, c.Level_1_Approver__c, c.Level_1_Approver_Email__c, c.Level_1_Approver_Comments__c, 'student');
                }
            }else if(c.RecordTypeId == recRecordTypeId){
                if(c.Approval_Status__c == 'Ethics Committee Approved'){
                    List<REC_Form_Submitted__c> recs = cases.get(c.Id).REC_Form_Submitted__r;

                    for(REC_Form_Submitted__c rec : recs){
                        List<Attachment> caseAttachments = new List<Attachment>();

                        Attachment certificateAttachment = getCaseAttachment(c.Id, certificates);
                        Attachment rescueAttachment = getCaseAttachment(c.Id, rescue);
                        Attachment chserAttachment = getCaseAttachment(c.Id, chser);
                        Attachment pisAttachment = getCaseAttachment(c.Id, pis);
                        Attachment icfAttachment = getCaseAttachment(c.Id, icf);
                        Attachment fspAttachment = getCaseAttachment(c.Id, fsp);

                        if(certificateAttachment != null){
                            caseAttachments.add(certificateAttachment);
                        }
                        if(rescueAttachment != null){
                            caseAttachments.add(rescueAttachment);
                        }
                        if(chserAttachment != null){
                            caseAttachments.add(chserAttachment);
                        }
                        if(pisAttachment != null){
                            caseAttachments.add(pisAttachment);
                        }
                        if(icfAttachment != null){
                            caseAttachments.add(icfAttachment);
                        }
                        if(fspAttachment != null){
                            caseAttachments.add(fspAttachment);
                        }

                        /*
                        if(certificates.size() > 0){
                            caseAttachments.add(certificates.get(0));
                        }

                        if(rescue.size() > 0){
                            caseAttachments.add(rescue.get(0));
                        }

                        if(chser.size() > 0){
                            caseAttachments.add(chser.get(0));
                        }

                        if(pis.size() > 0){
                            caseAttachments.add(pis.get(0));
                        }

                        if(icf.size() > 0){
                            caseAttachments.add(icf.get(0));
                        }

                        if(fsp.size() > 0){
                            caseAttachments.add(fsp.get(0));
                        }
                        */

                        for(Attachment attachment : caseAttachments){
                            attachments.add(new Attachment(ParentId = rec.Id, Body = attachment.Body, Name = attachment.Name));
                        }
                    }
                }
            }
        }

        if(attachments.size() > 0) insert attachments;
    }

    private static Attachment getCaseAttachment(Id caseID, List<Attachment> attachments){
        if(attachments.size() > 0){
            for(Attachment attachment : attachments){
                if(attachment.ParentId == caseID){
                    return attachment;
                }
            }
        }

        return null;
    }

    @future(callout=true)
    public static void updateStudentModuleTotalMC(String CaseID, Integer TotalMC){
        Case c = [select Id, Total_MC__c from Case where Id =: CaseID];
        c.Total_MC__c = Decimal.valueOf(TotalMC.format());
        
        update c;
    }
    
    @future(callout=true)
    public static void updateApprovalCase(String level, String caseID, String status1, String comment1, String status2, String comment2, String capstoneApproval){
        Case c = [select 
                    Id,Level_1_Approver_Status__c,Level_1_Approver_Comments__c,Level_2_Approver_Status__c,
                    Level_2_Approver_Comments__c,Capstone_Approval_Status__c,OwnerId 
                  from Case where Id =: caseId];
        
        if(level == '1'){
            c.Level_1_Approver_Status__c = status1;
            c.Level_1_Approver_Comments__c = comment1;    
        }else{
            c.Level_2_Approver_Status__c = status2;
            c.Level_2_Approver_Comments__c = comment2;
        }
        
        c.Capstone_Approval_Status__c = capstoneApproval;
        
        update c;
        
        if(c.Capstone_Approval_Status__c == 'Final Approval'){
            User user = [select Id from User where Id =: c.OwnerId];
            
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(caseID);
            Approval.ProcessResult result = Approval.process(req);    
        }
    }
    
    public static void sendCapstoneApprovalNotification(Case c, String level){
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Capstone Email Approval Template'];
        
        String approver = '';
        if(level.equalsIgnoreCase('1')){
            approver = c.Level_1_Approver__c;
        }else{
            approver = [select Name from Contact where Id =: c.Level_2_Approver__c].Name;
        }

        Contact student = [select Name,Student_Identity__c,Email,Current_Year__c,Major__c from Contact where Id =: c.ContactId];
        Capstone_Module__c project = [select Id,Project_Title__c,Project_Description__c,Supervision__c from Capstone_Module__c where Case__c =: c.Id];
        
        String link = 'dev-yalenus-dev.cs31.force.com/CapstoneModuleApproval?level=' + level + '&Email=' + (level == '1' ? c.Level_1_Approver_Email__c : c.Level_2_Approver_Email__c)  + '&id=' + project.Id;
        
        String htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!approver}', approver);
        htmlBody = htmlBody.replace('{!studentId}', student.Student_Identity__c);
        htmlBody = htmlBody.replace('{!studentName}', student.Name);
        htmlBody = htmlBody.replace('{!studentEmail}', Student.Email);
        htmlBody = htmlBody.replace('{!studentCurrentYear}', student.Current_Year__c);
        htmlBody = htmlBody.replace('{!studentMajor}', student.Major__c);
        htmlBody = htmlBody.replace('{!projectTitle}', project.Project_Title__c);
        htmlBody = htmlBody.replace('{!projectDescription}', project.Project_Description__c);
        htmlBody = htmlBody.replace('{!projectSupervision}', (String.isNotEmpty(project.Supervision__c) ? project.Supervision__c : ''));
        htmlBody = htmlBody.replace('{!approvalLink}', link);
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!approver}', approver);
        plainBody = plainBody.replace('{!studentId}', student.Student_Identity__c);
        plainBody = plainBody.replace('{!studentName}', student.Name);
        plainBody = plainBody.replace('{!studentEmail}', Student.Email);
        plainBody = plainBody.replace('{!studentCurrentYear}', student.Current_Year__c);
        plainBody = plainBody.replace('{!studentMajor}', student.Major__c);
        plainBody = plainBody.replace('{!projectTitle}', project.Project_Title__c);
        plainBody = plainBody.replace('{!projectDescription}', project.Project_Description__c);
        plainBody = plainBody.replace('{!projectSupervision}', (String.isNotEmpty(project.Supervision__c) ? project.Supervision__c : ''));
        plainBody = plainBody.replace('{!approvalLink}', link);
        
        // OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'donotreply@yale-nus.edu.sg'];                
        
        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
        
        // email.setOrgWideEmailAddressId(owea.get(0).Id);
        //email.setReplyTo(c.Level_1_Approver_Email__c);
        //email.setSenderDisplayName(c.Level_1_Approver_Email__c);
        email.toAddresses = new String[]{(level == '1' ? c.Level_1_Approver_Email__c : c.Level_2_Approver_Email__c)};
        //email.setTargetObjectId(c.Id);
        //email.setSaveAsActivity(true);
            
        email.setSubject(emailTemplate.Subject);
        email.setHtmlBody(htmlBody);
        email.setPlainTextBody(plainBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});
    }
    
    public static void sendCapstoneRejectedApprovalNotification(Case c, String rejectedName, String rejectedEmail, String rejectedComments, String recipient){
        User u = [select Id,Name,Email from User where id =: c.OwnerId];
        Contact student = [select Id,Name,Email from Contact where Id =: c.ContactId];
        Capstone_Module__c project = [select Id,Project_Title__c,Project_Description__c,Supervision__c from Capstone_Module__c where Case__c =: c.Id];
        
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Capstone Rejected Approval Email Template'];
        
        String htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!name}', (recipient == 'owner' ? u.Name : student.Name));
        htmlBody = htmlBody.replace('{!caseNumber}', c.CaseNumber);
        htmlBody = htmlBody.replace('{!projectTitle}', project.Project_Title__c);
        htmlBody = htmlBody.replace('{!projectDescription}', project.Project_Description__c);
        htmlBody = htmlBody.replace('{!projectSupervision}', (String.isNotEmpty(project.Supervision__c) ? project.Supervision__c : ''));
        htmlBody = htmlBody.replace('{!rejectedName}', rejectedName);
        htmlBody = htmlBody.replace('{!rejectedEmail}', rejectedEmail);
        htmlBody = htmlBody.replace('{!rejectedComments}', rejectedComments);
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!name}', (recipient == 'owner' ? u.Name : student.Name));
        plainBody = plainBody.replace('{!caseNumber}', c.CaseNumber);
        plainBody = plainBody.replace('{!projectTitle}', project.Project_Title__c);
        plainBody = plainBody.replace('{!projectDescription}', project.Project_Description__c);
        plainBody = plainBody.replace('{!projectSupervision}', (String.isNotEmpty(project.Supervision__c) ? project.Supervision__c : ''));
        plainBody = plainBody.replace('{!rejectedName}', rejectedName);
        plainBody = plainBody.replace('{!rejectedEmail}', rejectedEmail);
        plainBody = plainBody.replace('{!rejectedComments}', rejectedComments);
        
        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
        email.toAddresses = new String[]{(recipient == 'owner' ? u.Email : student.Email)};
        email.setSubject(emailTemplate.Subject);
        email.setHtmlBody(htmlBody);
        email.setPlainTextBody(plainBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});
    }
    
    /*
    Define max datetime, to remember the approver to approve the case
    */
    public static void setTimeApprovalReminder(List<Case> listCases){
        BusinessHours BH = [select id from businesshours where IsDefault=true limit 1];
        Datetime threeDaysBHFromNow = BusinessHours.Add(BH.Id, System.now(), 108000000); //108000000 (MilliSecond) = 3 days from created date
        
        for(Case c : listCases){
            if(c.Approval_Status__c == 'Pending Supervisor'){
                c.Max_Datetime_1st_Level_Approved__c = threeDaysBHFromNow;
            }
            else if(c.Approval_Status__c == 'Pending Head of Study'){
                c.Max_Datetime_2nd_Level_Approved__c = threeDaysBHFromNow;
            }
            else if(c.Approval_Status__c == 'Pending Ethics Committee'){
                c.Max_Datetime_3rd_Level_Approved__c = threeDaysBHFromNow;
            }
            //System.debug('currentuserId ' + currentuserId);
        }
    }
}