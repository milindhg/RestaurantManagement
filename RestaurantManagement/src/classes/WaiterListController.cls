global class WaiterListController{
    
    public static final String DELIVERED = 'Delivered';
    public static final String PICKED_UP = 'Picked Up'; 
    
    WebService static List<Order_Item__c> handleRefreshPage(){
        List<Order_Item__c> oitems = [SELECT Table_Number__c, Type__c, Delete_Status__c,
                                             Food_Item_Name__c, Quantity__c, Food_Order__c
                                      FROM   Order_Item__c
                                      WHERE  Status__c = 'Ready'
                                      AND    Delete_Status__c = 'No'
                                      ORDER BY CreatedDate];
        return oitems;
    }
    
    WebService static String updateOrderPickUp(String orderItemId,String foodOrderId){
        Order_Item__c orderItem = [SELECT status__c, Picked_Up_Time__c FROM Order_Item__c WHERE Id= :orderItemId];
        orderItem.status__c = PICKED_UP;
        orderItem.Picked_Up_Time__c = System.now();
        update orderItem;
        
        boolean isOrderDelivered = true;
        Food_Order__c foodOrder = [SELECT status__c FROM Food_Order__c WHERE ID= :foodOrderId];
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
        
        return 'Success';
    }
}