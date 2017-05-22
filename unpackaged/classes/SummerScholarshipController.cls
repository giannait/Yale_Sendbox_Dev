public without sharing class SummerScholarshipController extends ControllerBase{
    public Contact student { get; set; }
    public Scholarships__c schShip { get; set; }
    public String summerSch { get; set; }
    public Course__c course1 { get; set; }
    public Course__c course2 { get; set; }
    public Course__c course3 { get; set; }
    public Course__c course4 { get; set; }
    public Course__c course5 { get; set; }
    public Residential_College__c rc {set; get;}
    public List<Course__c> courses {set; get;}
    public String indexString {set; get;}
    public Attachment attachment {set; get;}
    public String yearTitle {set; get;} 
    
    private String nid;

    public SummerScholarshipController(){
        nid = Apexpages.currentPage().getParameters().get('nid');
        student = [select id, accountId, firstName, lastName,Matric_Year__c, Residential_College__c, Name_of_Head_of_Studies__c,Student_Identity__c,Graduation_Year__c from contact where NUSNET_ID__c=:nid];
        rc = [select Id,Name,Date_To__c,Date_From__c,Suite_No__c from Residential_College__c where Contact__c =: student.Id and Date_To__c = null limit 1];
        
        yearTitle = Label.Year_Title;
        
        schShip = new Scholarships__c();
        course1 = new Course__c();
        course2 = new Course__c();
        course3 = new Course__c();
        course4 = new Course__c();
        course5 = new Course__c();
        
        courses = new List<Course__c>();
        courses.add(new Course__c());
    }
    
    public void addRow(){
        courses.add(new Course__c());
    }
    
    public void deleteRow(){
        Integer index = Integer.valueOf(indexString) - 1;
        courses.remove(index);
    }
    
    public PageReference submitData(){
        string department = Apexpages.currentPage().getParameters().get('department');
        string subdepartment = Apexpages.currentPage().getParameters().get('subdepartment');
        string toe = Apexpages.currentPage().getParameters().get('toe');
    
        Savepoint sp = Database.setSavepoint();
    
        try{
            if(nid != null){
                // student.Student_identity__c = sid;
                List<Contact> listStudent = [select id, accountId, firstName, lastName, Matric_Year__c,Residential_College__c, Name_of_Head_of_Studies__c from contact where NUSNET_ID__c=:nid];
                
                if(!listStudent.isEmpty()){
                    student = listStudent[0];
                }
                else{
                    //student.Student_identity__c = sid;
                    insert student;
                }
            }
            else{
                insert student;
            }
            
            if(summerSch != null){
                schShip.Type__c = summerSch;
            }
            
            Case newCase = new Case();
            newCase.ContactId = student.id;
            newCase.Department__c = department;
            newCase.Sub_Department__c = subdepartment;
            newCase.Type_Of_Enquiry__c = toe;
            newCase.RecordTypeId = [select Id from RecordType where Name = 'Scholarship'].Id;
            newCase.Subject = toe;
            newCase.Status = 'Open';
            newCase.Origin = 'Web';
            newCase.Priority = 'High';
            
            insert newCase;
            
            schShip.Student__c = student.id;
            schShip.Case__c = newCase.Id;
            insert schShip;
            
            if(attachment.Body != null){
                attachment.ParentId = schShip.Id;
                insert attachment;
                attachment.Body = null;
            }
            
            if(course1.Institution__c !=null && course1.course__c != null){
                course1.Scholarships__c = schShip.Id;
                insert course1;
            }
            if(course2.Institution__c !=null && course2.course__c != null){
                course2.Scholarships__c = schShip.Id;
                insert course2;
            }
            if(course3.Institution__c !=null && course3.course__c != null){
                course3.Scholarships__c = schShip.Id;
                insert course3;
            }
            if(course4.Institution__c !=null && course4.course__c != null){
                course4.Scholarships__c = schShip.Id;
                insert course4;
            }
            if(course5.Institution__c !=null && course5.course__c != null){
                course5.Scholarships__c = schShip.Id;
                insert course5;
            }
            
            for(Course__c c:courses){
            	if(c.Institution__c !=null && c.course__c != null){
                    c.Scholarships__c = schShip.Id;
                    insert c;
                }    
            }
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data saved!'));
            
            return new PageReference('/CaseView?nid=' + nid); 
        }
        catch(DmlException e){
            Database.rollback(sp);

            System.debug('DmlException');
            System.debug(e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+' at line '+e.getLineNumber()));

            return null;
        }
        catch(Exception e){
            Database.rollback(sp);

            System.debug('Exception');
            System.debug(e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+' at line '+e.getLineNumber()));
            
            return null;
        }
    
        return cancel();
    }
    
    public PageReference cancel(){
        return new PageReference('/CaseView?nid=' + nid);
    }
}