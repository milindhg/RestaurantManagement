PushTopic pushTopic = new PushTopic();
pushTopic.Name = 'OrderAcceptedByChef';
pushTopic.Query = ' SELECT Id, Table_Number__c, Food_Item_Name__c, ' +
                  ' Type__c, Quantity__c, Food_Order__c, Delete_Status__c, Restaurant_Id__c ' +
                  ' FROM Order_Item__c ' +
                  ' WHERE Status__c = \'Accepted\'';
pushTopic.ApiVersion = 34.0;
pushTopic.NotifyForOperationCreate = true;
pushTopic.NotifyForOperationUpdate = true;
pushTopic.NotifyForOperationUndelete = true;
pushTopic.NotifyForOperationDelete = true;
pushTopic.NotifyForFields = 'Referenced';
insert pushTopic;