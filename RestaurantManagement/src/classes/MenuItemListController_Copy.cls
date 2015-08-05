global class MenuItemListController_Copy {
    
    
    
    public static List<DisplayMenuItems> ItemList;
    public static List<DisplayOffer> offerList;
    public String dietType;
    //public static String location=ApexPages.currentPage().getParameters().get('reqlocation');
    public String selLocation=ApexPages.currentPage().getParameters().get('reqlocation');
    public String tableNumber=ApexPages.currentPage().getParameters().get('tableid');
    public Decimal tableNo= Decimal.valueOf(tableNumber);
    public Id foodOrderId;
    
    //initializing the fo object with the current table food order.
    public Food_Order__c fo = getFoodOrder();
    //public Cart(){  }
    public List<DisplayCart> orderItemsList;
    public List<DisplayCart> activeCartItems;

    //public static strings for easy status string changes.
    public static final String PAID = 'Paid';
    public static final String NAVA = 'New';
    public static final String PENDING = 'Pending';
    public static final String ACCEPTED = 'Accepted';
    public static final String READY = 'Ready';
    public static final String PICKEDUP = 'Picked Up';
    public static final String DELIVERED = 'Delivered';
    //public static String table=ApexPages.currentPage().getParameters().get('tableid');
    
    public MenuItemListController_Copy(){
        selLocation=ApexPages.currentPage().getParameters().get('reqlocation');
        tableNumber=ApexPages.currentPage().getParameters().get('tableid');
        tableNo= Decimal.valueOf(tableNumber);
        System.debug(selLocation);
    }
    
    public MenuItemListController_Copy(String reqlocation, String tableid){
        selLocation=reqlocation;
        tableNumber=tableid;
        tableNo= Decimal.valueOf(tableNumber);
        System.debug(selLocation);
    }
    
    
    public Food_Order__c getFoodOrder(){
       
         List<Food_Order__c> existingOrder = [Select f.TotalPrice__c, f.TableNumber__c, f.SystemModstamp, 
            f.Status__c,  f.OrderId__c, f.OrderDateTime__c, f.Name, f.Location__c, f.Restaurant_Branch__r.Restaurant_ID__c, 
            f.LastViewedDate, f.LastReferencedDate, f.LastModifiedDate, f.LastModifiedById, 
            f.IsDeleted, f.Id, f.DeliveryTime__c, f.CreatedDate, f.CreatedById From Food_Order__c f
                                     where f.TableNumber__c=:tableNo and f.Status__c != 'Paid' and f.Restaurant_Branch__r.Restaurant_ID__c=:selLocation];
        System.debug('existingOrder is: !!!!' + existingOrder);
        if(existingOrder.isEmpty())
        {
            return null;
        }
        else
        {
    foodOrderId= existingOrder[0].Id;
    return [Select f.Price__c, f.Tax__c, f.TotalPrice__c, f.PriceEstimate__c, f.TaxEstimate__c, f.TotalPriceEstimate__c, f.TableNumber__c, f.SystemModstamp, 
                        f.Status__c, f.OrderId__c, f.OrderDateTime__c,f.Location__c,
                        f.Name, f.LastViewedDate, f.LastReferencedDate, 
                        f.LastModifiedDate, f.LastModifiedById, f.IsDeleted, f.Id, 
                        f.DeliveryTime__c, f.CreatedDate, f.CreatedById 
                        From Food_Order__c f 
                        where f.id=:foodOrderId];
        }
    }
    
    public List<DisplayCart> getOrderItemsList() {
        System.debug('FoodOrder is: !!!!' + fo);
        if(fo==null)
            return null;
        else{
            orderItemsList = new List<DisplayCart>();
            if(orderItemsList == null){
                orderItemsList = new List<DisplayCart>();
            }
            else{
                orderItemsList.clear();    
            }
                
            for(Order_Item__c item : [Select o.Type__c, o.Total_Price__c, o.Table_Number__c, 
                                        o.SystemModstamp, o.Status__c, o.Quantity__c, o.Price__c, 
                                        o.Name, o.LastViewedDate, o.LastReferencedDate, o.LastModifiedDate, 
                                        o.LastModifiedById, o.IsDeleted, o.Id, o.Food_Order__r.id,o.Food_Order__r.Location__c, o.Food_Order__r.Restaurant_Branch__r.Restaurant_ID__c, 
                                        o.Food_Item__r.id, o.CreatedDate, o.CreatedById 
                                        From Order_Item__c o
                                        where o.Food_order__c=:fo.id and o.Delete_Status__c <> 'Yes'
                                        order by o.Status__c desc, o.CreatedDate]){
                if(item.Status__c == ACCEPTED || item.Status__c == PICKEDUP || item.Status__c == READY || item.Status__c == PENDING || item.Status__c == DELIVERED)
                    orderItemsList.add(new DisplayCart(item));
            }
            System.debug('orderItemsList is: !!!!' + orderItemsList);
            return orderItemsList;
        }
    }

    //Method required for fetching the order items for modification in the modal popup. 
    //This method returns the json object containing the orderitems in serialized format to the front end javscript function.
    public String getOrderItemsListSerialized(){
        System.debug('Entered orderItemsListSerialized');
        System.debug('orderItemsList is: ' + orderItemsList);
        String jsonString = JSON.serializePretty(this.orderItemsList);
        System.debug('!!!!jsonString: ' + jsonString);
        return jsonString;
    }
    
    
    //Method to get the active cart items - which are not accepted yet.
    public List<DisplayCart> getActiveCartItems() {
        
        System.debug('FoodOrder is: !!!!' + fo);
        if(fo==null)
            return null;
        else{
            activeCartItems = new List<DisplayCart>();
            if(activeCartItems == null){
                activeCartItems = new List<DisplayCart>();
            }
            else{
                activeCartItems.clear();    
            }
            
                    for(Order_Item__c item : [Select o.Type__c, o.Total_Price__c, o.Table_Number__c, 
                                        o.SystemModstamp, o.Status__c, o.Quantity__c, o.Price__c, 
                                        o.Name, o.LastViewedDate, o.LastReferencedDate, o.LastModifiedDate, 
                                        o.LastModifiedById, o.IsDeleted, o.Id, o.Food_Order__c, 
                                        o.Food_Item__c, o.CreatedDate, o.CreatedById 
                                        From Order_Item__c o
                                        where o.Food_order__c=:fo.id
                                        AND o.Delete_Status__c <> 'Yes'
                                        ORDER BY o.CreatedDate]){
                if(item.Status__c == NAVA)
                    activeCartItems.add(new DisplayCart(item));
            }
            System.debug('activeCartItems is: !!!!' + activeCartItems);
            return activeCartItems;
        }

    }
    
    public void onAdd() {
           String id= system.CurrentPageReference().getParameters().get('id');
  

           Order_Item__c orderItem = [SELECT o.Quantity__c FROM Order_Item__c o where o.id=: id];
           
       orderItem.Quantity__c += 1;                                          
                   
           update orderItem;
                                          
       }
       
     
     public void onRemove() {
           String id= system.CurrentPageReference().getParameters().get('id');
  

           Order_Item__c orderItem = [SELECT o.Quantity__c FROM Order_Item__c o where o.id=: id];
           
       orderItem.Quantity__c -= 1;                                          
                   
           update orderItem;
                             
     }
     
     public void onDelete() {
          String id= system.CurrentPageReference().getParameters().get('id');
          Order_Item__c orderItem = [SELECT o.Quantity__c FROM Order_Item__c o where o.id=: id];
          orderItem.Delete_Status__c = 'Yes';
          update orderItem;                             
     }
     
     public boolean isOrderActive{
        get{
            if(foodOrderId==null)
                return false;
            return true;
        }
     }
     
     WebService static String placeOrder(String order_id, String location, String tableid) {
        
        if(order_id == null || order_id == ''){
            return '';
         }            
        else
          { Integer tableNo = Integer.valueOf(tableid);
            String est_del_time = '';
            Food_Order__c fo = [SELECT DeliveryTime__c, Status__c
                                FROM  Food_Order__c
                                WHERE Id = :order_id];
            
            //Food_Order__c fo = [SELECT fo.Status__c FROM Food_Order__c fo where fo.id=: order_id];
            fo.Status__c = PENDING;
            update fo;
            
            List<Order_Item__c> orderItems = [SELECT oi.Status__c FROM Order_Item__c oi where oi.Food_Order__c=:order_id AND oi.Status__c =:NAVA AND oi.Delete_Status__c = 'No'];
            for(Order_Item__c o : orderItems){
                o.Status__c = PENDING;            
            }
            update orderItems;  
            
            System.debug('Del time: '+fo.DeliveryTime__c+', Status: '+fo.Status__c);
            
            List<String> result= estimateDelivery(location, tableNo, order_id);
            est_del_time = result[0];
            fo.DeliveryTimeBy__c = est_del_time;
            fo.DeliveryTime__c = Integer.valueOf(result[1]);
            update fo;  
            
            return est_del_time;                                                            
        }
     }
     
     public void resetCart() {
        System.debug('foodOrderId is: !!!!' + foodOrderId);
        if(foodOrderId==null){
            return;
        }
        else{
            Food_Order__c fo = [SELECT fo.Status__c FROM Food_Order__c fo where fo.id=: foodOrderId];
            if(fo.Status__c==DELIVERED)
                fo.Status__c = DELIVERED;
            else
                fo.Status__c = PENDING;
            update fo;
            
            List<Order_Item__c> orderItems = [SELECT oi.Status__c FROM Order_Item__c oi where oi.Food_Order__c=:foodOrderId AND oi.Status__c =: NAVA];
            
            for(Order_Item__c o : orderItems){
                o.Delete_Status__c = 'Yes';            
            }
            
            update orderItems;                                                                 
        }
     }

     public void paidStatusUpdate(){
         //ID foodOrderId = ApexPages.CurrentPage().getParameters().get('foodOrderId');
         Food_Order__c foodOrder = [SELECT status__c FROM Food_Order__c WHERE ID=:foodOrderId];
         foodOrder.status__c = PAID;
         update foodOrder;
     }
     
     public PageReference payBill() {

         PageReference pageRef = Page.Bill_New;
         pageRef.getParameters().put('orderId', foodOrderId);
         pageRef.getParameters().put('reqlocation', selLocation);
         pageRef.getParameters().put('tableid', tableNumber);                  
         System.debug('PageRef------------------->'+pageRef);
         pageRef.setRedirect(true);
         return pageRef;
         }

     
     public PageReference test() {
         PageReference pageRef = Page.Bill;
//        PageReference pageRef = new PageReference('/apex/Bill');
        System.debug('PageRef------------------->'+pageRef);
         pageRef.setRedirect(true);
  //       pageRef.getParameters().put('msg','success');
         return pageRef;
         }
     

     
     public Integer getCartSize(){
         if(activeCartItems==null){
             return 0;
         }
         return activeCartItems.size();
     }
    
    public List<DisplayMenuItems> getMenuItems(){
        System.debug('ItemList is: !!!!' + ItemList);
         System.debug('Diet Type'+ dietType);
        //if(ItemList==null){
            List<Food_Item__c> food_items;
            if(dietType==null){
                System.debug('WITHOUT Type'+ dietType);
             food_items=[Select Name, Category__c, Description__c,
                                                Spice_Level__c,Special__c, Item_Image__c, 
                                                Prep_Time__c,Calories__c,Status__c,Type__c  
                                                From Food_Item__c 
                                                where Status__c='enabled'];
            }else{
                System.debug('WITH Type');
               food_items=[Select Name, Category__c, Description__c,
                                                Spice_Level__c,Special__c, Item_Image__c, 
                                                Prep_Time__c,Calories__c,Status__c,Type__c  
                                                From Food_Item__c 
                                                where Status__c='enabled' and type__c=:dietType];
                        dietType=null;                
            }
            ItemList = new List<DisplayMenuItems>();
            for(Food_Item__c item : food_items){
                List<PriceBook__c> price = [Select p.Price__c,p.NoItemsOrdered__c 
                                            from PriceBook__c p 
                                            where p.Food_Item__r.name=:item.Name 
                                            //and p.Location__c =:selLocation
                                            and p.Restaurant_Branch__r.Restaurant_ID__c =:selLocation
                                            and p.Price__c!=0]; 
                System.debug(item.Name);
                System.debug(selLocation);
                if(price.size() > 0)
                  ItemList.add(new DisplayMenuItems(item,price));
            }
       // }
        
        //Code to mark the 3 topselling items as star items 
        //Write the code to call comparator and sort the items list based on numof times ordered here.
        ItemList.sort();
        if(ItemList.size()>3){
        for(Integer i = 0; i < 3; i++){
            ItemList[i].starredItem = true;
       }
        }
        System.debug('Starred Items!!!!: ' + ItemList);
        return ItemList;
    }
    
       public List<DisplayOffer> getOffers(){
        System.debug('offerList is: !!!!' + offerList);
        if(offerList==null){
            
            offerList = new List<DisplayOffer>();
            for(Offers__c offer : [Select o.Id, Offer_Image__c, o.Food_Item__c, o.Food_Item__r.name,o.Discount__c, o.Description__c From Offers__c o]){
                //System.debug(item.Name);
                //System.debug(selLocation);
                offerList.add(new DisplayOffer(offer));
            }
        }
        
        return offerList;
    }
    
    @RemoteAction 
    WebService static String createOrderItem(String item, String quant, String table, String location, Id price){
        Decimal tableid= Decimal.valueOf(table);
        //Decimal itemPrice = Decimal.valueOf(price); 
        System.debug(item);
        System.debug(quant);
        System.debug(location);
        List<Food_Order__c> existingOrder = [Select f.TotalPrice__c, f.TableNumber__c, f.Location__c,f.SystemModstamp, 
            f.Status__c, f.OrderId__c, f.OrderDateTime__c, f.Name, 
            f.LastViewedDate, f.LastReferencedDate, f.LastModifiedDate, f.LastModifiedById, 
            f.IsDeleted, f.Id, f.DeliveryTime__c, f.CreatedDate, f.CreatedById From Food_Order__c f
                                     where f.TableNumber__c=:tableid and f.Status__c != 'Paid' 
                                             and 
                                             f.Restaurant_Branch__r.Restaurant_ID__c =:location
                                            ];
                
        if(existingOrder.isEmpty()){
            System.debug('Order Not Found');
                List<Restaurant__c> resto_list=[Select r.Zip__c, r.SystemModstamp, r.Street_Address__c, r.State__c,
                                     r.Restaurant_ID__c, r.Phone__c, r.OwnerId, r.Name, r.Manager__c,
                                     r.LastViewedDate, r.LastReferencedDate, r.LastModifiedDate, 
                                     r.LastModifiedById, r.LastActivityDate, r.IsDeleted, r.Id, 
                                     r.Email__c, r.CreatedDate, r.CreatedById, r.Country__c, r.City__c, 
                                     r.Branch__c, r.Apartment_Suite__c From Restaurant__c r where r.Restaurant_ID__c=:location];
                    
                //Restaurant__c restaurant = [Select r.Id from Restaurant__c r where r.Restaurant_ID__c=:location];
                System.debug('Resturant is'  + resto_list[0].Id);
                Food_Order__c order = new Food_Order__c();
                order.Status__c='New';
                order.TableNumber__c=tableid;
                order.Restaurant_Branch__c = resto_list[0].Id;
                insert order;  
        }               
        
        List<Food_Order__c> orders = [Select f.TotalPrice__c, f.TableNumber__c, f.Location__c,f.SystemModstamp, 
            f.Status__c, f.OrderId__c, f.OrderDateTime__c, f.Name, 
            f.LastViewedDate, f.LastReferencedDate, f.LastModifiedDate, f.LastModifiedById, 
            f.IsDeleted, f.Id, f.DeliveryTime__c, f.CreatedDate, f.CreatedById From Food_Order__c f
                                     where f.TableNumber__c=:tableid and f.Status__c != 'Paid' and f.Restaurant_Branch__r.Restaurant_ID__c=:location ];
        String item_name= item;
        List<Food_Item__c> food_items= [Select f.Type__c, f.SystemModstamp, f.Status__c, 
                                        f.Prep_Time__c,f.Calories__c, f.OwnerId, f.Name, f.LastViewedDate, 
                                        f.LastReferencedDate, f.LastModifiedDate, f.LastModifiedById, 
                                        f.IsDeleted, f.Id, f.Description__c, f.CreatedDate, f.CreatedById, 
                                        f.Category__c From Food_Item__c f where f.Name=:item_name];
        
        Order_Item__c orderitem = new Order_Item__c();
        
        orderitem.Name= item;
        orderitem.Price__c= price;
        orderitem.Food_Item__c= food_items[0].Id;
        orderitem.Restaurant_Id__c= location;
        orderitem.Food_Order__c= orders[0].Id;
        //orderitem.Location__c= location;
        Id foodOrderI= orders[0].Id;
        orderitem.Quantity__c= decimal.valueOf(quant);
        orderitem.Status__c='New';
        insert orderitem;
        return orders[0].name;
        
    }
    
    //Dummy function to rerender the cart elements on selecting any item from the menu and clicking add.
    public PageReference sayHello() {
        //Call getFoodOrder to populate the current foodOrder and set it in global object.
        System.debug('Enter method sayHello!!!!');
        fo=getFoodOrder();
        System.debug('fo FoodOrder now is: ' + fo);
        return null;
    }
    
    public PageReference getItemsByType(){
         dietType=ApexPages.currentPage().getParameters().get('type');
        //getMenuItems();
        System.debug(dietType);
        return null;
    }
    
    public PageReference getAllItems(){
        dietType=null;
        return null;
    }
    
    Webservice static List<String> getFoodOrderStatus(String tableid, String location){
      List<String> result_list = new List<String>();
      
      Restaurant__c r = [SELECT Id
                         FROM Restaurant__c
                         WHERE Restaurant_Id__c = :location];
      
      Id resto_id = r.Id;                   
      Decimal table_no = Decimal.valueOf(tableid); 
      
      Food_Order__c f = [SELECT Id, Status__c, DeliveryTimeBy__c
                         FROM   Food_Order__c
                         WHERE  TableNumber__c = :table_no 
                         AND    Restaurant_Branch__c = :resto_id
                         AND    Status__c != 'Paid'];
      
      result_list.add(f.Status__c);
      result_list.add(f.DeliveryTimeBy__c);                   
      
      return result_list;                   
    
    }
    
    static List<String> estimateDelivery(String location, Integer tableNo, String order_id){
        Integer count = 0;
        Integer prep_factor = 5;
        Integer MIN_VALUE = -100;
        Integer max_time = MIN_VALUE;
        Integer prev_time = 0;
        Integer curr_item_time = 0;
        Integer prep_time = 0;
        Boolean flag = false;
        Integer est_del_time = 0;
        String am_pm = 'AM';
        String zero_hr = '';
        String zero_min = '';
        
        List<String> item_type = new List<String>{'Appetizer','Entree','Dessert'};
        List<String> result_list = new List<String>();
        //System.debug('Order Id: '+foodOrderId);
        
        List<Order_Item__c> queue = [SELECT Food_Item_Name__c, Item_Prep_Time__c, 
                                            Status__c, Quantity__c
                                     FROM   Order_Item__c
                                     WHERE  Status__c IN ('Pending','Accepted')
                                     AND    Restaurant_Id__c = :location
                                     AND    Delete_Status__c = 'No'
                                     ORDER BY Status__c desc, CreatedDate];                          
        
        List<Order_Item__c> items = [SELECT Name, Type__c, Item_Prep_Time__c, Quantity__c
                                     FROM   Order_Item__c
                                     WHERE  Status__c = 'New'
                                     AND    Table_Number__c = :tableNo
                                     AND    Delete_Status__c = 'No'
                                     AND    Restaurant_Id__c = :location];
                               
        Restaurant__c resto = [SELECT Id
                               FROM   Restaurant__c
                               WHERE  Restaurant_Id__c = :location];
        
        Id resto_id = resto.id;
        
        List<Chef__c> chef_list = [SELECT Name, Total_Chefs__c 
                                   FROM   Chef__c
                                   WHERE  Restaurant_Id__c = :resto_id];                            
        
        if(chef_list.size()>0){
            Integer total_chefs = (Integer)chef_list[0].Total_Chefs__c;
            
            for(Order_Item__c o : queue){
               count++;
                
               if(o.Quantity__c > 1) 
                  prep_time = ((Integer) o.Item_Prep_Time__c * (Integer)o.Quantity__c)/prep_factor;
               else
                  prep_time = (Integer) o.Item_Prep_Time__c;
                  
                
               if(max_time < prep_time)
                   max_time = prep_time;
               
               if(Math.mod(count, total_chefs) == 0){
                  prev_time+=max_time;
                  max_time = MIN_VALUE;
               }   
            }
            
            //System.debug('Count: '+count);
            //System.debug('Total Time before: '+prev_time);
            //System.debug('Max Time: '+max_time);
            
            if(count >= total_chefs  && max_time > 0)
               prev_time+=max_time;                           
            else
               prev_time = 0;                       
            
            //System.debug('Total Time after: '+prev_time);
                                         
            for(String it_type : item_type){
               for(Order_Item__c it : items){
                   if(it.Type__c == it_type){
                      if(it.Quantity__c > 1) 
                         prep_time = ((Integer) it.Item_Prep_Time__c * (Integer)it.Quantity__c)/prep_factor;
                      else
                         prep_time = (Integer) it.Item_Prep_Time__c; 
                      
                       curr_item_time = prep_time;
                      flag = true;
                      break;
                    }
                }
                if(flag)
                  break;
            }
             
            //System.debug('Curr Time: '+curr_item_time);
            //System.debug('Est Del Time: '+est_del_time);
            
            Integer hr = System.now().hour();
            Integer min = System.now().minute(); 
            
            min = prev_time + curr_item_time + min;
            
            if(min > 59){
              hr+= min/60;
              hr = Math.mod(hr,24);
              min=Math.mod(min,60);  
             }
            
            if(hr>=12)
              am_pm = 'PM';
            
            if(hr>12)
              hr-=12;
              
            if(hr<10)
              zero_hr = '0'+hr;
            else
              zero_hr = hr+'';
              
            if(min < 10)
              zero_min = '0'+min;
            else
              zero_min = min+''; 
            
            
            String result = zero_hr+':'+zero_min+' '+am_pm;
            result_list.add(result);
            result_list.add(prev_time + curr_item_time+'');  
            return result_list;
          }
        else
           return result_list;   
          
    }
}