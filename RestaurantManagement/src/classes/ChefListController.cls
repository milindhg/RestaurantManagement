global with sharing class ChefListController{
    public static final String ACCEPTED = 'Accepted';
    public static final String READY = 'Ready';
    public static final String PENDING = 'Pending';
    
    public Decimal estimateDelivery(){
        Integer tableNo = 1;
        Integer noOfChefs = 2;
        Decimal curr_item_time = 0;
        Boolean flag = false;
        
        List<String> item_type = new List<String>{'Appetizer','Entree','Dessert'};
        
        AggregateResult[] queue = [SELECT SUM(Item_Prep_Time__c) sum
             				       FROM   Order_Item__c
             				       WHERE  Status__c = 'Pending'];
        
        List<Order_Item__c> items = [SELECT Name, Type__c, Item_Prep_Time__c
             				         FROM   Order_Item__c
             				         WHERE  Status__c = 'New'
                                     AND    Table_Number__c = :tableNo];
                                         
         for(String it_type : item_type){
             for(Order_Item__c it : items){
                 if(it.Type__c == it_type){
                     curr_item_time = it.Item_Prep_Time__c;
                     flag = true;
                     break;
                 }
              }
             if(flag)
               break;
          }
                                         
        Decimal est_del_time = (Decimal)queue[0].get('sum')/noOfChefs + curr_item_time;
        return est_del_time;
        
    }
        
    WebService static String itemAcceptUpdate(String orderItemId,String foodOrderId){
        Order_Item__c orderedItem = [SELECT status__c FROM Order_Item__c WHERE ID= :orderItemId];
        orderedItem.status__c = ACCEPTED;
        update orderedItem;
        
        system.debug(orderedItem.id);
        Food_Order__c foodOrder = [SELECT status__c FROM Food_Order__c WHERE Id= :foodOrderId ];
        foodOrder.status__c = PENDING;
        update foodOrder;
       
        return 'success';
        
    }
    
    
    WebService static String itemReadyUpdate(String orderItemId){
         //Add code for notification push to waiter screen
        Order_Item__c orderedItem = [SELECT status__c FROM Order_Item__c WHERE ID= :orderItemId];
        orderedItem.status__c = READY;
        update orderedItem;
        return orderedItem.Id;
    }
}