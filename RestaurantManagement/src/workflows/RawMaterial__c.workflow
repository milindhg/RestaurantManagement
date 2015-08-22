<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Inventory_Alert</fullName>
        <ccEmails>shrukata@indiana.edu</ccEmails>
        <description>Inventory Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>chef@resto.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>customer@resto.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>resto@persistent.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>restomgr@resto.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vimalendu@resto.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>waiter@resto.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Inventory_Alert</template>
    </alerts>
    <alerts>
        <fullName>Inventory_Alerts</fullName>
        <ccEmails>shrukata@indiana.edu</ccEmails>
        <description>Inventory Alerts</description>
        <protected>false</protected>
        <recipients>
            <recipient>chef@resto.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>customer@resto.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>resto@persistent.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>restomgr@resto.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vimalendu@resto.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>waiter@resto.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Inventory_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_USED_TILL_NOW_field</fullName>
        <field>Used_till_now__c</field>
        <formula>Used_till_now__c  +  Used__c</formula>
        <name>Update USED TILL NOW field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Raw Material Alert</fullName>
        <actions>
            <name>Inventory_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>Available__c  &lt;=  threshold__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Inventory_Alerts</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RawMaterial__c.CreatedDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update USED TILL NOW</fullName>
        <actions>
            <name>Update_USED_TILL_NOW_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Used__c &gt;0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
