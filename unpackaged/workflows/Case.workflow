<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_notification_for_VR</fullName>
        <description>Approval notification for VR</description>
        <protected>false</protected>
        <recipients>
            <recipient>VR_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/VR_Approval_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Capstone_Final_Approval_Notification</fullName>
        <description>Capstone Final Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Capstone_Final_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_for_EC_v1</fullName>
        <description>Email notification for EC v1</description>
        <protected>false</protected>
        <recipients>
            <recipient>REC_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/REC_Approval_Notification_Email_Template_for_REC_Group</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_for_HoS</fullName>
        <description>Email notification for HoS</description>
        <protected>false</protected>
        <recipients>
            <field>REC_Head_of_Study__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/REC_Approval_Notification_Email_Template_for_HoS</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_for_REC_Group</fullName>
        <description>Email notification for REC Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>REC_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/REC_Approval_Notification_Email_Template_for_REC_Group</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_for_Registry_group_member_approved</fullName>
        <description>Email notification for Registry group member - approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>RC_Exec_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Registry_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Approval_Request_being_Approved</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_for_Registry_group_member_rejected</fullName>
        <description>Email notification for Registry group member - rejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>RC_Exec_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Registry_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Approval_Request_being_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_for_supervisor</fullName>
        <description>Email notification for supervisor</description>
        <protected>false</protected>
        <recipients>
            <field>REC_Supervisor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/REC_Approval_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_for_supervisor_hos_v1</fullName>
        <description>Email notification for supervisor hos v1</description>
        <protected>false</protected>
        <recipients>
            <field>REC_Head_of_Study__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/REC_Approval_Notification_Email_Template_for_HoS</template>
    </alerts>
    <alerts>
        <fullName>Notify_queue_members</fullName>
        <description>Notify queue members</description>
        <protected>false</protected>
        <recipients>
            <recipient>REC_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Department_Assignment_Email</template>
    </alerts>
    <alerts>
        <fullName>Notify_queue_members_after_3days_has_not_taken_the_ownership</fullName>
        <description>Notify queue members after 3days has not taken the ownership</description>
        <protected>false</protected>
        <recipients>
            <recipient>REC_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Department_Assignment_Email</template>
    </alerts>
    <alerts>
        <fullName>Notify_student_case_being_submitted_has_been_approved</fullName>
        <description>Notify student case being submitted has been approved</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Approval_Request_being_Approved</template>
    </alerts>
    <alerts>
        <fullName>Notify_student_case_being_submitted_has_been_rejected</fullName>
        <description>Notify student case being submitted has been rejected</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Approval_Request_being_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Notify_student_case_being_submitted_has_been_rejected_v1</fullName>
        <description>Notify student case being submitted has been rejected v1</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Approval_Request_being_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Notify_student_case_being_submitted_has_been_rejectedv1</fullName>
        <description>Notify student case being submitted has been rejectedv1</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Approval_Request_being_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Reminder_for_1st_level_approver_to_approve</fullName>
        <description>Reminder for 1st level approver to approve</description>
        <protected>false</protected>
        <recipients>
            <field>REC_Supervisor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Reminder_for_1st_level_approver_to_approve</template>
    </alerts>
    <alerts>
        <fullName>Reminder_for_1st_level_approver_to_approve_v2</fullName>
        <description>Reminder for 1st level approver to approve</description>
        <protected>false</protected>
        <recipients>
            <field>REC_Supervisor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Reminder_for_1st_level_approver_to_approve</template>
    </alerts>
    <alerts>
        <fullName>Reminder_for_2nd_level_approver_to_approve</fullName>
        <description>Reminder for 2nd level approver to approve</description>
        <protected>false</protected>
        <recipients>
            <field>REC_Head_of_Study__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Reminder_for_2nd_level_approver_to_approve</template>
    </alerts>
    <alerts>
        <fullName>Reminder_for_3rd_level_approver_to_approve</fullName>
        <description>Reminder for 3rd level approver to approve</description>
        <protected>false</protected>
        <recipients>
            <recipient>REC_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Template/Reminder_for_3nd_level_approver_to_approve</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_Approved_Supervisor</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Head of Study</literalValue>
        <name>Approval Status - Approved Supervisor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_EC_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Ethics Committee Approved</literalValue>
        <name>Approval Status - EC Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Head_of_Study_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Head of Study Rejected</literalValue>
        <name>Approval Status - Head of Study Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Pending_Supervisor</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Supervisor</literalValue>
        <name>Approval Status - Pending Supervisor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_EC_rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Ethics Committee Rejected</literalValue>
        <name>Approval Status to EC rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Pending_Head_of_Study</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Ethics Committee</literalValue>
        <name>Approval Status to Pending Head of Study</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Pending_Supervisor</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Supervisor</literalValue>
        <name>Approval Status to Pending Supervisor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Supervisor_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Supervisor Rejected</literalValue>
        <name>Approval Status to Supervisor Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capstone_Status_Approved_Update</fullName>
        <field>Capstone_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Capstone Status Approved Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capstone_Status_Rejected_Update</fullName>
        <field>Capstone_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Capstone Status Rejected Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HoS_Rejected_v1</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Head of Study Rejected</literalValue>
        <name>HoS Rejected v1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_Pending_Hos_v1</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Head of Study</literalValue>
        <name>Update Approval Status to Pending Hos v1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_Pending_VR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending VR</literalValue>
        <name>Update Approval Status to Pending VR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_VR_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>VR Approved</literalValue>
        <name>Update Approval Status to VR Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_VR_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>VR Rejected</literalValue>
        <name>Update Approval Status to VR Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_Closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update Case Status - Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Queue_taking_ownership_datetime</fullName>
        <description>Update Queue taking ownership datetime with current datetime value</description>
        <field>Queue_taking_ownership_datetime__c</field>
        <formula>NOW()</formula>
        <name>Update Queue taking ownership datetime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Case - reminder for 1st approver to approve</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending Supervisor</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_for_1st_level_approver_to_approve_v2</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Max_Datetime_1st_Level_Approved__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case - reminder for 2nd approver to approve</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending Head of Study</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_for_2nd_level_approver_to_approve</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Max_Datetime_2nd_Level_Approved__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case - reminder for 3rd approver to approve</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending Ethics Committee</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_for_3rd_level_approver_to_approve</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Max_Datetime_3rd_Level_Approved__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case - reminder for queue members to take ownership</fullName>
        <active>false</active>
        <formula>LEFT(OwnerId,3) = &apos;00G&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notify_queue_members_after_3days_has_not_taken_the_ownership</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Queue_taking_ownership_datetime__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case - update datetime ownership has been taken</fullName>
        <actions>
            <name>Update_Queue_taking_ownership_datetime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(AND( ISCHANGED(OwnerId), OR( OwnerId = $User.Id, AND( LEFT(PRIORVALUE(OwnerId),3) = &apos;00G&apos;, LEFT(OwnerId,3) = &apos;005&apos; ) ) ), LEFT(OwnerId,3) = &apos;005&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
