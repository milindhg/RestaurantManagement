<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert</fullName>
        <ccEmails>shruthi_katapally@persistent.com</ccEmails>
        <description>Alert trial</description>
        <protected>false</protected>
        <recipients>
            <recipient>resto@persistent.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SalesNewCustomerEmail</template>
    </alerts>
    <alerts>
        <fullName>Alert_to_make_a_Purchase</fullName>
        <ccEmails>shruthi_katapally@persistent.com</ccEmails>
        <description>Alert to make a Purchase</description>
        <protected>false</protected>
        <recipients>
            <recipient>resto@persistent.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SalesNewCustomerEmail</template>
    </alerts>
</Workflow>
