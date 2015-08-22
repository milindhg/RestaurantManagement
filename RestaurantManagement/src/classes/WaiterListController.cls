global with sharing class WaiterListController{
    
    public static final String DELIVERED = 'Delivered';
    public static final String PICKED_UP = 'Picked Up'; 
    public String selectedRestaurant;
    public List<SelectOption> restaurantData;
    
    public String getSelectedRestaurant() {
        return selectedRestaurant;
    }
       
    public void setSelectedRestaurant(String recType) {
       this.selectedRestaurant= recType;
    }
    

    
    public static String getRestoId(){
       User u  = [SELECT Restaurant_Id__c
                  FROM   User
                  WHERE  Id = :UserInfo.getUserId()];
           
       String rid = u.Restaurant_Id__c;
       
       return rid;
    }
    
    WebService static List<Order_Item__c> handleRefreshPage(){
        String rid = WaiterListController.getRestoId();
        
        List<Order_Item__c> oitems = [SELECT Table_Number__c, Type__c, Delete_Status__c,
                                             Food_Item_Name__c, Quantity__c, Food_Order__c
                                      FROM   Order_Item__c
                                      WHERE  Status__c = 'Ready'
                                      AND    Delete_Status__c = 'No' 
                                      AND    Restaurant_Id__c = :rid
                                      ORDER BY CreatedDate];
        return oitems;
    }
    
    WebService static String updateOrderPickUp(String orderItemId,String foodOrderId){
        Order_Item__c orderItem = [SELECT status__c, Picked_Up_Time__c FROM Order_Item__c WHERE Id= :orderItemId];
        orderItem.status__c = PICKED_UP;
        orderItem.Picked_Up_Time__c = System.now();
        update orderItem;
        
        return 'Success';
    }
}