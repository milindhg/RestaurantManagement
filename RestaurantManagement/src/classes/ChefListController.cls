global class ChefListController{
    public static final String ACCEPTED = 'Accepted';
    public static final String READY = 'Ready';
    public static final String PENDING = 'Pending';
    
    @RemoteAction 
    WebService static String itemAcceptUpdate(String orderItemId,String foodOrderId){
        Order_Item__c orderedItem = [SELECT status__c FROM Order_Item__c WHERE ID= :orderItemId];
        orderedItem.status__c = ACCEPTED;
        update orderedItem;
        
        system.debug(orderedItem.id);
        Food_Order__c foodOrder = [SELECT status__c FROM Food_Order__c WHERE Id= :foodOrderId ];
        foodOrder.status__c = PENDING;
        update foodOrder;
        
        String idString = orderedItem.id+' '+foodOrder.Id;
        return 'success';
        
    }
    
    
    @RemoteAction
    WebService static void itemReadyUpdate(String orderItemId){
         //Add code for notification push to waiter screen
        Order_Item__c orderedItem = [SELECT status__c FROM Order_Item__c WHERE ID= :orderItemId];
        orderedItem.status__c = READY;
        update orderedItem;
    }
}