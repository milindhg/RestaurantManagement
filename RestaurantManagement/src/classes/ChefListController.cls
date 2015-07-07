public class ChefListController{
    public static final String ACCEPTED = 'Accepted';
    public static final String READY = 'Ready';
    
    public void acceptItem(){
        String orderItemName = ApexPages.CurrentPage().getParameters().get('orderItem');
        Order_Item__c orderedItem = new Order_Item__c();
        orderedItem = [SELECT status__c FROM Order_Item__c WHERE Name= :orderItemName];
        orderedItem.status__c = ACCEPTED;
        update orderedItem;
        ID foodOrderId = ApexPages.CurrentPage().getParameters().get('foodOrderID');
    }
    
     public void itemReadyUpdate(){
         //Add code for notification push to waiter screen
        String orderItemName = ApexPages.CurrentPage().getParameters().get('itemName');
        Order_Item__c orderedItem = new Order_Item__c();
        orderedItem = [SELECT status__c FROM Order_Item__c WHERE Name= :orderItemName];
        orderedItem.status__c = READY;
        update orderedItem;
    }
}