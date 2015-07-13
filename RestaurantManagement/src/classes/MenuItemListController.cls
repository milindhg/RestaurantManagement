global class MenuItemListController {
    
    
    
    public static List<DisplayMenuItems> ItemList;
    public static List<DisplayOffer> offerList;
    //public static String location=ApexPages.currentPage().getParameters().get('reqlocation');
    public String selLocation=ApexPages.currentPage().getParameters().get('reqlocation');
    public String tableNumber=ApexPages.currentPage().getParameters().get('tableid');
    public Decimal tableNo= Decimal.valueOf(tableNumber);
    public Id foodOrderId='a0537000000RF93';
    Food_Order__c fo = getFoodOrder();
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
    foodOrderId= existingOrder[0].Id;
    return [Select f.Price__c, f.Tax__c, f.TotalPrice__c, f.PriceEstimate__c, f.TaxEstimate__c, f.TotalPriceEstimate__c, f.TableNumber__c, f.SystemModstamp, 
                        f.Status__c, f.OwnerId, f.OrderId__c, f.OrderDateTime__c, 
                        f.Name, f.LastViewedDate, f.LastReferencedDate, 
                        f.LastModifiedDate, f.LastModifiedById, f.IsDeleted, f.Id, 
                        f.DeliveryTime__c, f.CreatedDate, f.CreatedById 
                        From Food_Order__c f 
                        where f.id=:foodOrderId];
    }
    
    public List<DisplayCart> getOrderItemsList() {     
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
                                    where o.Food_order__c=:fo.id
                                    order by o.Status__c]){
            if(item.Status__c == 'Accepted' || item.Status__c == 'Picked Up' || item.Status__c == 'Ready' || item.Status__c == 'Pending')
                orderItemsList.add(new DisplayCart(item));
        }
        //fo = getFoodOrder();
        return orderItemsList;
    }
    
    public List<DisplayCart> getActiveCartItems() {
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
                                    where o.Food_order__c=:fo.id]){
            if(item.Status__c == 'New')
                activeCartItems.add(new DisplayCart(item));
        }
        //fo = getFoodOrder();
        return activeCartItems;


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
          delete orderItem;                             
     }
     
     public void placeOrder() {
        String id= system.CurrentPageReference().getParameters().get('id');  
        Food_Order__c fo = [SELECT fo.Status__c FROM Food_Order__c fo where fo.id=: id];
        fo.Status__c = 'Pending';
        update fo;
        
        List<Order_Item__c> orderItems = [SELECT oi.Status__c FROM Order_Item__c oi where oi.Food_Order__c=:id AND oi.Status__c = 'New'];
        for(Order_Item__c o : orderItems){
            o.Status__c = 'Pending';            
        }
        update orderItems;                                                                 
     }
     
     public void resetCart() {
        String id= system.CurrentPageReference().getParameters().get('id');  
        Food_Order__c fo = [SELECT fo.Status__c FROM Food_Order__c fo where fo.id=: id];
        fo.Status__c = 'Pending';
        update fo;
        
        List<Order_Item__c> orderItems = [SELECT oi.Status__c FROM Order_Item__c oi where oi.Food_Order__c=:id AND oi.Status__c = 'New'];
        delete orderItems;                                                                 
     }

     public void paidStatusUpdate(){
         //ID foodOrderId = ApexPages.CurrentPage().getParameters().get('foodOrderId');
         Food_Order__c foodOrder = [SELECT status__c FROM Food_Order__c WHERE ID=:foodOrderId];
         foodOrder.status__c = PAID;
         update foodOrder;
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
        
        if(ItemList==null){
            
            ItemList = new List<DisplayMenuItems>();
            for(Food_Item__c item : [Select Name, Category__c, Description__c,Special__c, Item_Image__c, Prep_Time__c,Status__c,Type__c  From Food_Item__c where Status__c='enabled' ]){
                List<PriceBook__c> price = [Select p.Price__c from PriceBook__c p where p.Food_Item__r.name=:item.Name and p.Location__c =: selLocation]; 
                System.debug(item.Name);
                System.debug(selLocation);
                ItemList.add(new DisplayMenuItems(item,price));
            }
        }
        
        return ItemList;
    }
    
       public List<DisplayOffer> getOffers(){
        
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
                                        f.Prep_Time__c, f.OwnerId, f.Name, f.LastViewedDate, 
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
    
    
    public class DisplayMenuItems{
        private Food_Item__c availableItems;
        private Decimal pricetag;
        private String imgurl;
        private PriceBook__c book;
        
        public DisplayMenuItems(Food_Item__c item, List<PriceBook__c> price){
            this.availableItems= item;
            this.pricetag= price[0].Price__c;
            this.book = price[0];
            
        }
        
        // public String status{
        //    get{if(actionList.containsKey(availDeals.Name)){
        
        //      return actionList.get(availDeals.Name);}
        
        //    else return 'Available';}
        
        //}
        
        
        // public String getUrl{
        //   get{
        //     List<StaticResource> resourceName= new List<StaticResource>();
        //   resourceName= [Select s.Name from StaticResource s where s.Name=:availDeals.Name];
        // if(!resourceName.isEmpty()){
        //return URL.getSalesforceBaseUrl().toExternalForm()+'/resource'+'/'+availDeals.Name;
        //}else{
        //     return URL.getSalesforceBaseUrl().toExternalForm()+'/resource/sample';
        // }
        //}
        //}
        
        //public Boolean isAccepted{
        // get{if(actionList.containsKey(availDeals.Name)){
        
        //   return true;}
        
        // else return false;}
        
        //}
        public String name{
            get{return availableItems.Name;}
        }
        
        public Id priceBook{
            get{return this.book.Id;}
        }
        
        public String category{
            get{return availableItems.Category__c;}
        }
                
                public Decimal price{
            get{return this.pricetag;}
        }        
        public String description{
            get{return availableItems.Description__c;}
        }
        
        public Decimal preptime{
            get{return availableItems.Prep_Time__c;}
        }
        
        public String status{
            get{return availableItems.Status__c;}
        }
        
        public boolean isSpecial{
            get{return availableItems.Special__c;}
        }
        public String typ{
            get{return availableItems.Type__c;}
        }
        
        public String getimgurl(){
           imgurl = availableItems.Item_Image__c+'';
           Integer st_index = imgurl.IndexOf('src');
           Integer end_index = imgurl.lastIndexOf('\"');
           
           Integer len = end_index - (st_index+5);
           imgurl = imgurl.mid(st_index+5,len).replace('&amp;','&');
           return imgurl; 
       }
        
        // public Object diet{
          //  get{return availableItems.Diet__c;}
        //}
        
    }
    
    public class DisplayOffer{
        private Offers__c availableOffers;
        private Decimal pricetag;
        private String imgurl;
        private PriceBook__c book;
        
        public DisplayOffer(Offers__c offer){
            this.availableOffers= offer;
            
        }

        public String name{
            get{return availableOffers.Food_Item__r.name;}
        }
        
        public Decimal discount{
            get{return availableOffers.discount__c;}
        }        
        public String description{
            get{return availableOffers.Description__c;}
        }
        
       
        
    }
    public class DisplayCart {
    private Order_Item__c cartItem;

    public DisplayCart(Order_Item__c item){
        this.cartItem = item;
    }
    
    //public Id id = apexpages.currentpage().getparameters().get('id');
    //public Id id = apexpages.currentpage().getparameters().get('id');
    
    public Id id
    {
        get { return cartItem.id; }
    }

    public String Name
    {
        get { return cartItem.name;  }
    }
    
    public Decimal price
    {
        //Code to get the price from the lookup column and return it here.
        get { return 10.00; }
    }
    
    public Decimal quantity
    {
        get { return cartItem.Quantity__c; } 
    }

    public Decimal totalPrice
    {
        get { return cartItem.Total_Price__c; } 
    }      

    public String status 
    {
        get { return cartItem.status__c; }
    }
       
    public String type
    {
        get { return cartItem.type__c; }
    }
    
    public Food_Item__c foodItem
    {
        get { return cartItem.Food_Item__r;}
    }
    
    public Food_Order__c foodOrder
    {
        get { return cartItem.Food_Order__r; }
    }

    public Decimal tableNumber
    {
        get { return cartItem.table_number__c; }
    }
}

}