global with sharing class ChefListController{
    public static final String ACCEPTED = 'Accepted';
    public static final String READY = 'Ready';
    public static final String PENDING = 'Pending';
    public String selectedlocation;
    public Integer noofchefs;
    
    public Integer getnoofchefs(){
       System.debug('get: '+noofchefs);
       return noofchefs;
    }
    
    public void setnoofchefs(Integer no_chefs) {
        System.debug('set: '+no_chefs);
        this.noofchefs = no_chefs;
    }
    
    public String getselectedlocation() {
        System.debug('Select Loc: '+selectedlocation);
        return selectedlocation;
    }
        
    public void setselectedlocation(String recType) {
        this.selectedlocation= recType;
    }
    
    public List<SelectOption> getMaxChefs(){
       List<SelectOption> ChefList= new List<SelectOption>();
       ChefList.add(new SelectOption('Select','Select')); 
       Decimal total_chefs;
       
       String loc = Apexpages.currentPage().getparameters().get('loc');
       
       System.debug('Loc: '+loc);
       List<Chef__c> chefs = [SELECT Location__c, Total_Chefs__c
                              FROM Chef__c];
        
       for(Chef__c c : chefs)     
                           
         if(c.Location__c == loc){
           total_chefs = c.Total_Chefs__c;
           break;
         }
         
       for(Integer i=1;i<=total_chefs;i++)
         ChefList.add(new SelectOption(i+'',i+''));
         
       return ChefList;  
       
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
    
    public PageReference goToChefOrders(){
       String s = noofchefs+'_Hello';
       System.debug('s: '+s);
       PageReference pg = new PageReference('/apex/chef_pending_orders?location='+selectedlocation+'&noofchefs='+s);
       return pg;
    }
    
    public Decimal estimateDelivery(){
        Integer tableNo = 1;
        Integer count = 0;
        Integer MIN_VALUE = -100;
        Integer max_time = MIN_VALUE;
        Integer total_time = 0;
        Integer curr_item_time = 0;
        Integer prep_time = 0;
        Boolean flag = false;
        Integer est_del_time = 0;
        
        
        List<String> item_type = new List<String>{'Appetizer','Entree','Dessert'};
        
        List<Order_Item__c> queue = [SELECT Food_Item_Name__c, Item_Prep_Time__c, Status__c
                                     FROM   Order_Item__c
                                     WHERE  Status__c IN ('Pending','Accepted')
                                     ORDER BY Status__c desc, CreatedDate];
        
        List<Order_Item__c> items = [SELECT Name, Type__c, Item_Prep_Time__c
                                     FROM   Order_Item__c
                                     WHERE  Status__c = 'New'
                                     AND    Table_Number__c = :tableNo];
                                     
        Chef__c chef = [SELECT Total_Chefs__c
                        FROM Chef__c
                        WHERE Location__c = 'Ohio'];                             
                                     
        Integer total_chefs = (Integer)chef.Total_Chefs__c;
        
        for(Order_Item__c o : queue){
           count++;
           prep_time = (Integer) o.Item_Prep_Time__c;
           if(max_time < prep_time )
               max_time = prep_time;
           
           if(Math.mod(count, total_chefs) == 0){
              total_time+=max_time;
              max_time = MIN_VALUE;
           }   
        }
        
        total_time+=max_time;                           
                                     
        for(String it_type : item_type){
           for(Order_Item__c it : items){
               if(it.Type__c == it_type){
                  prep_time = (Integer) it.Item_Prep_Time__c;
                  curr_item_time = prep_time;
                  flag = true;
                  break;
                }
            }
            if(flag)
              break;
        }
                                         
        est_del_time = total_time + curr_item_time;
        return est_del_time;
        
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