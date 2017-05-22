public class CaseDetailController extends CommunityControllerBase{

    public Case c {set; get;}
    public Contact contact {set; get;}
    public Attachment attachment {set; get;}
    // public List<Case_Conversation__c> caseConversations {set; get;}
    //public Case_Conversation__c caseConversation {set; get;}
    public CaseComment caseComment {set; get;}
    public List<CaseComment> caseComments {set; get;}
    public List<Attachment> attHistory {set; get;}

    public Attachment humanSubjectAttachment {set; get;}
    public Attachment rescueAttachment {set; get;}
    public Attachment chserAttchment {set; get;}
    public Attachment participantAttachment {set; get;}
    public Attachment informedAttachment {set; get;}
    public Attachment fieldworkAttachment {set; get;}

    private final String humanSubject = 'humanSubject';
    private final String rescue = 'rescue';
    private final String chser = 'chser';
    private final String participant = 'participant';
    private final String informed = 'informed';
    private final String fieldwork = 'fieldwork';
    
    private Map<String, String> params;
    
    public CaseDetailController(){
        params = getParameters();

        if(String.isNotEmpty(params.get('error'))){
            showErrorMessage(params.get('error'));
        }

        c = [select Id,Department__c,Sub_Department__c,CaseNumber,Status,Type_of_Enquiry__c,Description,ContactId,Approval_Status__c from Case where Id =: params.get('cid') and ContactId =: ContactID];
        contact = [select Id,Name,Student_Identity__c,Email,NUSNET_ID__c from Contact where Id =: c.ContactId];
        attHistory = [select Id,Name,CreatedBy.Name from Attachment where ParentId =: c.Id order by CreatedDate desc, Name];
        
        loadConversations();
        loadCaseComments();
        
        attachment = new Attachment();
        //caseConversation = new Case_Conversation__c();
        caseComment = new CaseComment();

        humanSubjectAttachment = new Attachment();
        rescueAttachment = new Attachment();
        chserAttchment = new Attachment();
        participantAttachment = new Attachment();
        informedAttachment = new Attachment();
        fieldworkAttachment = new Attachment();
    }
    
    public void loadCaseComments(){
        caseComments = [select CommentBody, IsPublished, ParentId, CreatedById, CreatedDate, IsDeleted from CaseComment where ParentId =: c.Id and IsDeleted = false order by CreatedDate DESC];
    }
    
    public void loadConversations(){
        //caseConversations = [select Id,Name,Email__c,Message__c,Sender__c,Case__c from Case_Conversation__c where Case__c =: c.Id order by CreatedDate DESC];
    }
    
    public PageReference save(){
        Savepoint sp = Database.setSavepoint();

        // update case;
        try{
            update c;
        }catch(Exception e){
            Database.rollback(sp);
            this.showErrorMessage(e.getMessage());
        }

        // insert attachment
        try{
            if(attachment.Body != null){
                attachment.ParentId = c.Id;
                insert attachment;
            }
        }catch(Exception e){
            showErrorMessage('Upload attachment failed : ' + e.getMessage());
        }finally {
            attachment = new Attachment();
        }

        // insert human subject attachment
        if(!insertAttachment(sp, c, humanSubjectAttachment, humanSubject)){
            return error('Error upload human subjects attachment');
        }

        // insert rescue attachment
        if(!insertAttachment(sp,c,rescueAttachment, rescue)){
            return error('error upload rescue attachment');
        }

        // insert chser attchment
        if(!insertAttachment(sp, c, chserAttchment, chser)){
            return error('error upload chser attachment');
        }

        // insert participant attachment
        if(!insertAttachment(sp,c,participantAttachment, participant)){
            return error('error upload participant attachment');
        }

        // insert informed attachment
        if(!insertAttachment(sp, c, informedAttachment, informed)){
            return error('error upload informed attachment');
        }

        // insert fieldwork attachment
        if(!insertAttachment(sp, c, fieldworkAttachment, fieldwork)){
            return error('error upload fieldwork attachment');
        }

        try{
            if(String.isNotEmpty(caseComment.CommentBody)){
                caseComment.IsPublished = false;
                caseComment.ParentId = c.Id;
                
                insert caseComment;
            }
            
            return toCaseView();
        }catch(Exception e){
            showErrorMessage('Update Case Error : ' + e.getMessage());
        }Finally{
            caseComment = new CaseComment();
        }
        
        return null;
    }
    
    public void saveConversation(){
        //try{
        //    if(String.isNotBlank(caseConversation.Message__c)){
        //        caseConversation.Case__c = c.Id;
        //        caseConversation.Sender__c = contact.Name;
        //        caseConversation.Email__c = contact.Email;
        //        
        //        insert caseConversation;
        //        
        //        loadConversations();
        //        caseConversation = new Case_Conversation__c();
        //    }    
        //}catch(Exception e){
        //    showErrorMessage(e.getMessage());
       // }
    }

    private Boolean insertAttachment(Savepoint sp, Case c, Attachment att, String type){
        Boolean boo = true;

        if(att.Body != null){
            try{
                att.ParentId = c.Id;
                att.Name = attachmentFileName(att.Name, type);

                insert att;
            }catch(Exception e){
                Database.rollback(sp);
                this.showErrorMessage(type + ' error : ' + e.getMessage());
                boo = false;
            }finally {
                att = new Attachment();
            }
        }

        return boo;
    }

    private String attachmentFileName(String filename, String type){
        String name = '';
        Datetime dt = System.now();
        String timeString = dt.format('HHmmss');
        String dateString = dt.format('ddMMyyyy');

        if(type.equals(humanSubject)){
            name = 'Certificate.';
        }else if(type.equals(rescue)){
            name = 'RESCUE.';
        }else if(type.equals(chser)){
            name = 'CHSER.';
        }else if(type.equals(participant)){
            name = 'PIS.';
        }else if(type.equals(informed)){
            name = 'ICF.';
        }else if(type.equals(fieldwork)){
            name = 'FSP.';
        }

        if(String.isNotEmpty(name)){
            name += dateString + '.' + timeString + '.' + filename;
        }

        return name;
    }

    private PageReference error(String error){
        PageReference pr = Page.CaseDetail;
        pr.setRedirect(true);
        pr.getParameters().put('error', error);
        pr.getParameters().put('cid', params.get('cid'));

        return pr;
    }
    
    public PageReference cancel(){
        return toCaseView();
    }
    
    private PageReference toCaseView(){
        PageReference pr = Page.CaseView;
        pr.setRedirect(true);
        return pr;
    }
}