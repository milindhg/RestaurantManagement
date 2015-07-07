global class WaiterListController{
    
    public static final String DELIVERED = 'Delivered';
    public static final String PICKED_UP = 'Picked Up'; 
    
    @RemoteAction
    WebService static void updateOrderPickUp(String orderItemName,Id foodOrderId){
        Order_Item__c orderItem = [SELECT status__c FROM Order_Item__c WHERE Name= :orderItemName];
        orderItem.status__c = PICKED_UP;
        update orderItem;
        
        boolean isOrderDelivered = true;
        Food_Order__c foodOrder = [SELECT status__c FROM Food_Order__c WHERE ID= :orderItem.Food_Order__r.ID];
        List<Order_Item__c> orderItemList = [SELECT Food_Item_Name__c,Price__c,Quantity__c,Table_Number__c,Total_Price__c,status__c FROM Order_Item__c WHERE food_order__r.ID= :foodOrder.ID];
        for(Order_Item__c orderItemVal: orderItemList){
            if(orderItemVal.status__c <> PICKED_UP){
                isOrderDelivered = false;
                break;
            }
        }
        if(isOrderDelivered){
            foodOrder.status__c = DELIVERED;
            update foodOrder;
        }
    }
}