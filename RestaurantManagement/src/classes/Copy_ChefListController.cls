global with sharing class Copy_ChefListController{

    public static final String ACCEPTED = 'Accepted';
    public static final String READY = 'Ready';
    public static final String PENDING = 'Pending';
    public String selectedlocation;
    public String selectedNoChefs;
    
    public List<SelectOption> getnoofchefs(){
      List<SelectOption> noofchefs = new List<SelectOption>();
      noofchefs.add(new SelectOption('Select','Select'));
      
      String rid = Copy_ChefListController.getRestoId();
      Restaurant__c resto = [SELECT Id
                             FROM   Restaurant__c
                             WHERE  Restaurant_Id__c = :rid];
        
      Id resto_id = resto.id;
        
      List<Chef__c> chef_list = [SELECT Name, Total_Chefs__c 
                                 FROM   Chef__c
                                 WHERE  Restaurant_Id__c = :resto_id];
      
      if(chef_list.size() > 0){
        Integer total_chefs = (Integer)chef_list[0].Total_Chefs__c;             
        
        for(Integer i=1;i<=total_chefs;i++)
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
    
    public String getselectedNoChefs() {
        return selectedNoChefs;
    }
       
    public void setselectedNoChefs(String recType) {
       this.selectedNoChefs = recType;
    }
    
    public static String getRestoId(){
       User u  = [SELECT Restaurant_Id__c
                  FROM   User
                  WHERE  Id = :UserInfo.getUserId()];
           
       String rid = u.Restaurant_Id__c;
       
       return rid;
    }
    
    public List<SelectOption> getLocationdata()
    {   
        String rid = Copy_ChefListController.getRestoId();
        Restaurant__c r = [SELECT Branch__c, City__c, State__c, Zip__c
                           FROM   Restaurant__c
                           WHERE  Restaurant_Id__c = :rid];
                   
        String location = r.Branch__c + ', ' + r.City__c+ ', ' + r.State__c + ', ' + r.Zip__c;
        
        List<SelectOption> locationList = new List<SelectOption>();
        locationList.add(new SelectOption('Select','Select'));
        locationList.add(new SelectOption(location,location));
        
        return locationList;
        
    }
    
    Webservice static String updateNoChefs(String noOfChefs){
        
        String rid = Copy_ChefListController.getRestoId();

        Restaurant__c resto = [SELECT Id
                               FROM   Restaurant__c
                               WHERE  Restaurant_Id__c = :rid];
        
        Id resto_id = resto.id;
        
        List<Chef__c> chef_list = [SELECT Name, Total_Chefs__c 
                                   FROM   Chef__c
                                   WHERE  Restaurant_Id__c = :resto_id];
        
        if(chef_list.size() > 0){
          chef_list[0].Total_Chefs__c = Decimal.valueOf(noOfChefs);
          update chef_list[0]; 
          return rid;
         }
        else
          return '';
        
     }
    
    WebService static List<Order_Item__c> handleRefreshPage(){
        String rid = Copy_ChefListController.getRestoId();
        
        List<Order_Item__c> oitems = [SELECT Table_Number__c, Type__c, Delete_Status__c,
                                             Food_Item_Name__c, Quantity__c, Food_Order__c,
                                             Status__c 
                                      FROM   Order_Item__c
                                      WHERE  Status__c in ('Pending','Accepted')
                                      AND    Delete_Status__c = 'No'
                                      AND    Restaurant_Id__c = :rid
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