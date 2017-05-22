public class RECFormController extends CommunityControllerBase{

    //public BusinessHours BH  {set; get;}
    public Contact contact {set; get;}
    public Case c {set; get;}
    public Attachment humanSubjectAttachment {set; get;}
    public Attachment rescueAttachment {set; get;}
    public Attachment chserAttchment {set; get;}
    public Attachment participantAttachment {set; get;}
    public Attachment informedAttachment {set; get;}
    public Attachment fieldworkAttachment {set; get;}

    public String supervisorID {set; get;}
    public String headOfStudyID {set; get;}
    public List<SelectOption> supervisorOptions {set; get;}
    public List<SelectOption> headOfStudyOptions {set; get;}

    private Map<String,String> params;

    private final String humanSubject = 'humanSubject';
    private final String rescue = 'rescue';
    private final String chser = 'chser';
    private final String participant = 'participant';
    private final String informed = 'informed';
    private final String fieldwork = 'fieldwork';

    public RECFormController(){
        params = this.getParameters();

        if(String.isNotEmpty(params.get('error'))){
            this.showErrorMessage(params.get('error'));
        }

        contact = [
            select
                Id,Name,Student_Identity__c,Email,Matric_Year__c,NRIC__c,Current_Year__c,Degree_Name__c,Length_of_Course__c,Major__c,Minor__c,NUSNET_ID__c
            from Contact
            where Id =: ContactID
        ];

        c = new Case();
        c.ContactId = contact.Id;
        c.Department__c = params.get('department');
        c.Type_Of_Enquiry__c = params.get('toe');
        c.RecordTypeId = [select Id from RecordType where Name = 'REC Form Submission'].Id;
        if(params.get('subdepartment') != 'null'){
            c.Sub_Department__c = params.get('subdepartment');
        }

        humanSubjectAttachment = new Attachment();
        rescueAttachment = new Attachment();
        chserAttchment = new Attachment();
        participantAttachment = new Attachment();
        informedAttachment = new Attachment();
        fieldworkAttachment = new Attachment();

        supervisorOptions = new List<SelectOption>();
        supervisorOptions.add(new SelectOption('none', '--None--'));
        //supervisorOptions.add(new SelectOption('005p0000001WTfC', 'Test Supervisor'));

        headOfStudyOptions = new List<SelectOption>();
        headOfStudyOptions.add(new SelectOption('none', '--None--'));
        //headOfStudyOptions.add(new SelectOption('005p0000001WTfH', 'Test Head of Study'));

        List<User> supervisorUsers = [select Id,Name,Type__c from User where Type__c includes('Supervisor')];
        for(User user : supervisorUsers){
            supervisorOptions.add(new SelectOption(user.Id, user.Name));
        }

        List<User> headOfStudyUsers = [select Id,Name,Type__c from User where Type__c includes('Head of Study')];
        for(User user : headOfStudyUsers){
            headOfStudyOptions.add(new SelectOption(user.Id, user.Name));
        }
    }

    public PageReference save(){
        // form validation
        if(supervisorID == null || supervisorID == 'none'){
            return error('Supervisor cannot be null!');
        }

        if(headOfStudyID == null || headOfStudyID == 'none'){
            return error('Head of Study cannot be null!');
        }

        if(humanSubjectAttachment.Body == null){
            return error('Human Subjects Training Certificate document cannot be null!');
        }

        Savepoint sp = Database.setSavepoint();
        
        //BH = [select id from businesshours where IsDefault=true limit 1];
        //Datetime maxDate1stLvlApproval = BusinessHours.Add(BH.Id, System.now(), 108000000); //108000000 (MilliSecond) = 3 days from created date

        c.Subject = params.get('toe');
        c.Status = 'Open';
        c.Origin = 'Web';
        c.Priority = 'High';
        c.REC_Supervisor__c = supervisorID;
        c.REC_Head_of_Study__c = headOfStudyID;
        c.Approval_Status__c = 'Pending Supervisor';
        //c.Max_Datetime_1st_Level_Approved__c = maxDate1stLvlApproval;
        //c.Queue_taking_ownership_datetime__c = maxDate1stLvlApproval;
        c.setOptions(dmo);
        insert c;

        REC_Form_Submitted__c rec = new REC_Form_Submitted__c();
        rec.Case__c = c.Id;
        rec.Contact__c = c.ContactId;
        rec.Supervisor__c = c.REC_Supervisor__c;
        rec.Head_of_Study__c = c.REC_Head_of_Study__c;
        insert rec;

        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitted for approval. Please approve.');
        req.setObjectId(c.Id);
        Approval.process(req);
        

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

        return cancel();
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

    private PageReference error(String error){
        String url = '/RECForm?department='+params.get('department')+'&subdepartment='+params.get('subdepartment')+'&toe='+params.get('toe')+'&status=new';
        PageReference pr = new PageReference(url);
        pr.setRedirect(true);
        pr.getParameters().put('error', error);

        return pr;
    }

    public PageReference cancel(){
        PageReference pr = Page.CaseView;
        pr.setRedirect(true);
        return pr;
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
}