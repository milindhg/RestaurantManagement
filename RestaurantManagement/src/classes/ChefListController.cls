global with sharing class ChefListController{

    public static final String ACCEPTED = 'Accepted';
    public static final String READY = 'Ready';
    public static final String PENDING = 'Pending';
    public String selectedlocation;
    
    public List<SelectOption> getnoofchefs(){
      List<SelectOption> noofchefs = new List<SelectOption>();
      noofchefs.add(new SelectOption('Select','Select'));
      
      Chef__c c = [SELECT Total_Chefs__c 
                   FROM Chef__c
                   WHERE Location__c = :selectedlocation];
      
      Integer total_chefs = (Integer)c.Total_Chefs__c;             
      for(Integer i=1;i<=total_chefs;i++){
        noofchefs.add(new SelectOption(i+'',i+''));
       }
        
      return noofchefs;        
    }
    
    public String getselectedlocation() {
        return selectedlocation;
    }
       
    public void setselectedlocation(String recType) {
       this.selectedlocation= recType;
    }
    
    public List<SelectOption> getLocationdata()
    {                   
        List<Table__c> tb= [Select f.Location__c from Table__c f];
        
        Map<String,String> mp = new Map<String,String>();
        Integer count=1;
        for(Table__c loc:tb){
            mp.put(loc.Location__c,loc.Location__c);
            count++;            
        }
        List<SelectOption> LocationList= new List<SelectOption>();
        LocationList.add(new SelectOption('Select','Select'));
        for(String key: mp.keySet()){
            
            LocationList.add(new SelectOption(mp.get(key),mp.get(key)));
            
        }
       
        return LocationList;
    }
    
    Webservice static String updateNoChefs(String location, String noOfChefs){
        List<Chef__c> chef_list = [SELECT Total_Chefs__c 
                                   FROM Chef__c
                                   WHERE Location__c = :location];
        
        if(chef_list.size() > 0){
          chef_list[0].Total_Chefs__c = Decimal.valueOf(noOfChefs);
          update chef_list[0]; 
          return noOfChefs;
         }
        else
          return '';
        
     }
    
    WebService static List<Order_Item__c> handleRefreshPage(){
        List<Order_Item__c> oitems = [SELECT Table_Number__c, Type__c, Delete_Status__c,
                                             Food_Item_Name__c, Quantity__c, Food_Order__c
                                      FROM   Order_Item__c
                                      WHERE  Status__c = 'Pending'
                                      AND    Delete_Status__c = 'No'
                                      ORDER BY CreatedDate];
        return oitems;
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