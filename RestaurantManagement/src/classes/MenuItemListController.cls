global class MenuItemListController {
    
    
    
    public static List<DisplayMenuItems> ItemList;
    public static List<DisplayOffer> offerList;
    //public static String location=ApexPages.currentPage().getParameters().get('reqlocation');
    public String selLocation=ApexPages.currentPage().getParameters().get('reqlocation');
    public String tableNumber=ApexPages.currentPage().getParameters().get('tableid');
    public Decimal tableNo= Decimal.valueOf(tableNumber);
    public Id foodOrderId;
    public Food_Order__c fo = getFoodOrder();
    //public Cart(){  }
    public List<DisplayCart> orderItemsList;
    public List<DisplayCart> activeCartItems;
    public static final String PAID = 'Paid';
    //public static String table=ApexPages.currentPage().getParameters().get('tableid');
    
    public MenuItemListController(){
        selLocation=ApexPages.currentPage().getParameters().get('reqlocation');
        tableNumber=ApexPages.currentPage().getParameters().get('tableid');
        tableNo= Decimal.valueOf(tableNumber);
        System.debug(selLocation);
    }
    
    public Food_Order__c getFoodOrder(){
         List<Food_Order__c> existingOrder = [Select f.TotalPrice__c, f.TableNumber__c, f.SystemModstamp, 
            f.Status__c, f.OwnerId, f.OrderId__c, f.OrderDateTime__c, f.Name, 
            f.LastViewedDate, f.LastReferencedDate, f.LastModifiedDate, f.LastModifiedById, 
            f.IsDeleted, f.Id, f.DeliveryTime__c, f.CreatedDate, f.CreatedById From Food_Order__c f
                                     where f.TableNumber__c=:tableNo and f.Status__c != 'Paid' ];
        System.debug('existingOrder is: !!!!' + existingOrder);
        if(existingOrder.isEmpty())
        {
            return null;
        }
        else
        {
    foodOrderId= existingOrder[0].Id;
    return [Select f.Price__c, f.Tax__c, f.TotalPrice__c, f.PriceEstimate__c, f.TaxEstimate__c, f.TotalPriceEstimate__c, f.TableNumber__c, f.SystemModstamp, 
                        f.Status__c, f.OwnerId, f.OrderId__c, f.OrderDateTime__c, 
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
                                        o.LastModifiedById, o.IsDeleted, o.Id, o.Food_Order__c, 
                                        o.Food_Item__c, o.CreatedDate, o.CreatedById 
                                        From Order_Item__c o
                                        where o.Food_order__c=:fo.id and o.Delete_Status__c <> 'Yes'
                                        order by o.Status__c]){
                if(item.Status__c == 'Accepted' || item.Status__c == 'Picked Up' || item.Status__c == 'Ready' || item.Status__c == 'Pending')
                    orderItemsList.add(new DisplayCart(item));
            }
            System.debug('orderItemsList is: !!!!' + orderItemsList);
            return orderItemsList;
        }
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
                                        AND o.Delete_Status__c <> 'Yes']){
                if(item.Status__c == 'New')
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
     
     public void placeOrder() {
        System.debug('foodOrderId is: !!!!' + foodOrderId);
        if(foodOrderId==null){
            return;
        }
        else{
            Food_Order__c fo = [SELECT fo.Status__c FROM Food_Order__c fo where fo.id=: foodOrderId];
            fo.Status__c = 'Pending';
            update fo;
            
            List<Order_Item__c> orderItems = [SELECT oi.Status__c FROM Order_Item__c oi where oi.Food_Order__c=:foodOrderId AND oi.Status__c = 'New'];
            for(Order_Item__c o : orderItems){
                o.Status__c = 'Pending';            
            }
            update orderItems;                                                                 
        }
     }
     
     public void resetCart() {
        System.debug('foodOrderId is: !!!!' + foodOrderId);
        if(foodOrderId==null){
            return;
        }
        else{
            Food_Order__c fo = [SELECT fo.Status__c FROM Food_Order__c fo where fo.id=: foodOrderId];
            fo.Status__c = 'Pending';
            update fo;
            
            List<Order_Item__c> orderItems = [SELECT oi.Status__c FROM Order_Item__c oi where oi.Food_Order__c=:foodOrderId AND oi.Status__c = 'New'];
            
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
        Double tableNo = Double.valueOf(ApexPages.CurrentPage().getParameters().get('tableid'));   
        String loc = ApexPages.CurrentPage().getParameters().get('reqlocation');
        
        List<Order_Item__c> oitems = [SELECT Id, Name, Food_Item__c
                                       FROM   Order_Item__c
                                       WHERE  Status__c ='Delivered'
                                       AND    Table_Number__c = :tableNo];

        List<Food_Item__c> fitems = new List<Food_Item__c>();
        for(Integer i=0;i<oitems.size();i++){
            Id food_item = oitems[i].Food_Item__c;
        
            Food_Item__c f = [SELECT Id, 
                               (SELECT NoItemsOrdered__c
                                FROM   PriceBooks__r
                                WHERE  Location__c = :loc
                                )
             FROM Food_Item__c
             WHERE Id = :food_item];
            
             PriceBook__c p = f.PriceBooks__r;
             p.NoItemsOrdered__c = p.NoItemsOrdered__c + 1;
            
             fitems.add(f);
            
        }
        
        update fitems;
     
        PageReference pageRef = Page.Bill;
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
         return activeCartItems.size();
     }
    
    public List<DisplayMenuItems> getMenuItems(){
        System.debug('ItemList is: !!!!' + ItemList);
        if(ItemList==null){
            
            ItemList = new List<DisplayMenuItems>();
            for(Food_Item__c item : [Select Name, Category__c, Description__c,Special__c, Item_Image__c, Prep_Time__c,Calories__c,Status__c,Type__c  From Food_Item__c where Status__c='enabled' ]){
                List<PriceBook__c> price = [Select p.Price__c,p.NoItemsOrdered__c from PriceBook__c p where p.Food_Item__r.name=:item.Name and p.Location__c =: selLocation]; 
                System.debug(item.Name);
                System.debug(selLocation);
                ItemList.add(new DisplayMenuItems(item,price));
            }
        }
        
        //Code to mark the 3 topselling items as star items 
        //Write the code to call comparator and sort the items list based on numof times ordered here.
        ItemList.sort();
        for(Integer i = 0; i < 3; i++){
            ItemList[i].starredItem = true;
        }
        System.debug('Starred Items!!!!: ' + ItemList);
        return ItemList;
    }
    
       public List<DisplayOffer> getOffers(){
        System.debug('offerList is: !!!!' + offerList);
        if(offerList==null){
            
            offerList = new List<DisplayOffer>();
            for(Offers__c offer : [Select o.Id, o.Food_Item__c, o.Food_Item__r.name,o.Discount__c, o.Description__c From Offers__c o]){
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
        List<Food_Order__c> existingOrder = [Select f.TotalPrice__c, f.TableNumber__c, f.SystemModstamp, 
            f.Status__c, f.OwnerId, f.OrderId__c, f.OrderDateTime__c, f.Name, 
            f.LastViewedDate, f.LastReferencedDate, f.LastModifiedDate, f.LastModifiedById, 
            f.IsDeleted, f.Id, f.DeliveryTime__c, f.CreatedDate, f.CreatedById From Food_Order__c f
                                     where f.TableNumber__c=:tableid and f.Status__c != 'Paid' ];
                
        if(existingOrder.isEmpty()){
                Food_Order__c order = new Food_Order__c();
                order.Status__c='New';
                order.TableNumber__c=tableid;
                insert order;  
        }               
        
        List<Food_Order__c> orders = [Select f.TotalPrice__c, f.TableNumber__c, f.SystemModstamp, 
            f.Status__c, f.OwnerId, f.OrderId__c, f.OrderDateTime__c, f.Name, 
            f.LastViewedDate, f.LastReferencedDate, f.LastModifiedDate, f.LastModifiedById, 
            f.IsDeleted, f.Id, f.DeliveryTime__c, f.CreatedDate, f.CreatedById From Food_Order__c f
                                     where f.TableNumber__c=:tableid and f.Status__c != 'Paid'];
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
        orderitem.Food_Order__c= orders[0].Id;
        Id foodOrderI= orders[0].Id;
        orderitem.Quantity__c= decimal.valueOf(quant);
        
        orderitem.Status__c='New';
        insert orderitem;
        return orders[0].name;
        
    }
    
    public static String rerenderCart(){
        return null;
    }
    
    //Dummy function to rerender the cart elements on selecting any item from the menu and clicking add.
    public PageReference sayHello() {
        //Call getFoodOrder to populate the current foodOrder and set it in global object.
        System.debug('Enter method sayHello!!!!');
        fo=getFoodOrder();
        System.debug('fo FoodOrder now is: ' + fo);
        return null;
    }
    
    

}