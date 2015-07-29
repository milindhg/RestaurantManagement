global class WaiterListController{
    
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
    
    public List<SelectOption> getRestaurantData()
    {                   
        List<Table__c> tb= [Select f.Location__c from Table__c f];
        
        Map<String,String> mp = new Map<String,String>();
        Integer count=1;
        for(Table__c loc:tb){
            mp.put(loc.Location__c,loc.Location__c);
            count++;            
        }
        List<SelectOption> RestaurantList= new List<SelectOption>();
        RestaurantList.add(new SelectOption('Select','Select'));
        for(String key: mp.keySet()){
            
            RestaurantList.add(new SelectOption(mp.get(key),mp.get(key)));
            
        }
       
        return RestaurantList;
    }
    
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
        
        return 'Success';
    }
}