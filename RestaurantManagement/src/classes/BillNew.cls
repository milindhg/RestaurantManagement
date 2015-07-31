global with sharing class BillNew{

    //public String foodOrderId = 'a0537000000RI9b';
    public String foodOrderId = ApexPages.currentPage().getParameters().get('orderId');
    public String selLocation=ApexPages.currentPage().getParameters().get('reqlocation');
    public String tableNumber=ApexPages.currentPage().getParameters().get('tableid');
    public Decimal tableNo= Decimal.valueOf(tableNumber);
    
    public String SelectedFQ;
    public String SelectedService;
    public String SelectedOAE;
    public String likes;
    public String unlikes;
    public String tip;
  
    public String getSelectedFQ() {
        return SelectedFQ;
    }
     
    public void setSelectedFQ(String recType) {
        this.SelectedFQ= recType;
    }

     public String gettip() {
        return tip;
    }
     
    public void settip(String recType) {
        this.tip= recType;
    }    
    
    public String getSelectedService() {
        return SelectedService;
    }
     
    public void setSelectedService (String recType) {
        this.SelectedService= recType;
    }
    
    public String getSelectedOAE () {
        return SelectedOAE;
    }
     
    public void setSelectedOAE (String recType) {
        this.SelectedOAE = recType;
    }
    
    
    public String getlikes() {
        System.debug('Likes: '+likes);
        return likes;
    }
     
    public void setlikes(String recType) {
        this.likes= recType;
    }
    
    public String getunlikes() {
        return unlikes;
    }
     
    public void setunlikes(String recType) {
        this.unlikes= recType;
    }
     
    
    public BillNew(){  }
    public List<DisplayCart> orderItemsList;
 
    public static final String PAID = 'Paid';
    
    Food_Order__c fo = getFoodOrder();
    
    public Food_Order__c getFoodOrder(){
    return [SELECT f.Price__c, f.Tax__c, f.TotalPrice__c, f.FinalPrice__c,f.PriceEstimate__c, f.TaxEstimate__c, f.TotalPriceEstimate__c, f.TableNumber__c, f.SystemModstamp, 
                        f.Status__c, f.OrderId__c, f.OrderDateTime__c,
                        f.Name, f.LastViewedDate, f.LastReferencedDate, 
                        f.LastModifiedDate, f.LastModifiedById, f.IsDeleted, f.Id, 
                        f.DeliveryTime__c, f.CreatedDate, f.CreatedById 
                        From Food_Order__c f 
                        where f.id=:foodOrderId];
    }
                            
    public BillNew(ApexPages.StandardController controller) {}
    public BillNew(ApexPages.StandardSetController controller) {}  
  
    //Method to get the billed order items
    public List<DisplayCart> getOrderItemsList() {     
        orderItemsList = new List<DisplayCart>();
        if(orderItemsList == null){
            orderItemsList = new List<DisplayCart>();
        }
        else{
            orderItemsList.clear();    
        }
        
        Map<Id, DisplayCart> itemMap = new Map<Id, DisplayCart>(); 
            
        for(Order_Item__c item : [Select o.Type__c, o.Total_Price__c, o.Table_Number__c, 
                                    o.SystemModstamp, o.Status__c, o.Quantity__c, o.Price__c, 
                                    o.Name, o.LastViewedDate, o.LastReferencedDate, o.LastModifiedDate, 
                                    o.LastModifiedById, o.IsDeleted, o.Id, o.Food_Order__c, 
                                    o.Food_Item__c, o.CreatedDate, o.CreatedById, o.Tax__c 
                                    From Order_Item__c o
                                    where o.Food_order__c=:fo.id and o.Delete_Status__c <> 'Yes'
                                    order by o.Status__c]){
            if(item.Status__c != 'New'){
                    DisplayCart displayCart = new DisplayCart(item);
                    System.debug('Map-----------------------------------');
                    System.debug(itemMap);
                    System.debug('Cart-----------------------------------');
                    System.debug(displayCart);
                    System.debug('-----------------------------------');
                    if(itemMap.containsKey(displayCart.foodItemId)){
                        DisplayCart cart = itemMap.get(displayCart.foodItemId);
                        Decimal quantity = cart.quantity;
                        quantity += item.Quantity__c;
                        cart.quantity = quantity;
                        cart.totalPrice += item.Total_Price__c;
                        System.debug('Updated Cart-----------------------------------');
                        System.debug(cart);
                        itemMap.put(cart.foodItemId, cart);
                        System.debug('Inside****');

                    }
                    else{                        
                       itemMap.put(displayCart.foodItemId, displayCart);
                       System.debug('Else****');
                    }
                }
        }
        //fo = getFoodOrder();
        for(DisplayCart displayCart: itemMap .values()){
            orderItemsList.add(displayCart);
            
           
            }
        
        return orderItemsList;
    }
    
    public void inserttip()
    {
         Food_Order__c foodOrder = [SELECT status__c, TotalPrice__c, FinalPrice__c,TableNumber__c, Tax__c, Name FROM Food_Order__c WHERE ID=:foodOrderId];
         if(String.isBlank(tip))
         { System.Debug('tip'+'NULL');
             foodOrder.Tip__c=0;}
        else{
         foodOrder.Tip__c =Decimal.valueOf(tip);}
         update foodOrder;
         System.Debug('tip'+tip);
         System.debug('price and tip'+foodOrder.FinalPrice__c);
    }
    
     public void insertfeedback()
    {
    Feedback__c fb = new Feedback__c();
    fb.Food_Quality__c=SelectedFQ;
    fb.Overall_Experience__c=SelectedOAE;
    fb.Service__c=SelectedService;
    fb.What_I_liked__c=likes;
    fb.What_must_have_been_there__c=unlikes;
    insert fb;
    }
    
    /*public static String getRestoId(){
       User u  = [SELECT Restaurant_Id__c
                  FROM   User
                  WHERE  Id = :UserInfo.getUserId()];
           
       String rid = u.Restaurant_Id__c;
       
       return rid;
    }*/
    
     public void paidStatusUpdate(){
         Food_Order__c foodOrder = [SELECT status__c, TotalPrice__c, TableNumber__c, Tax__c, Name FROM Food_Order__c WHERE ID=:foodOrderId];
         foodOrder.status__c = PAID;
         update foodOrder;

        Restaurant__c resto = [SELECT Id
                               FROM   Restaurant__c
                               WHERE  Restaurant_Id__c = :selLocation];
        
         Id resto_id = resto.id;
         
         
         Bill__c bill = new Bill__c();  
         bill.TableNumber__c = foodOrder.TableNumber__c;
         bill.Price__c = foodOrder.TotalPrice__c;
         bill.Tax__c = foodOrder.Tax__c;
         bill.Restaurant_ID__c = resto_id ;
         insert bill;
         
          for(DisplayCart displayCart: orderItemsList){
            
            BIll_Item__c billItem= new BIll_Item__c();
            billItem.Name = displayCart.Name;
            billItem.Quantity__c = displayCart.quantity;
            billItem.TotalPrice__c = displayCart.totalPrice;
            billItem.Bill__c = bill.Id;
//            billItem.Tax__c = 3.4// TODO;
            insert billItem;   
            
            PriceBook__c priceBook = [SELECT NoItemsOrdered__c FROM PriceBook__c WHERE ID=:displayCart.priceBook];
            priceBook.NoItemsOrdered__c += 1;
            update priceBook;  
                      
       }     
       
     }
     
     public PageReference finish(){
         PageReference pageRef = Page.Menu_Demo_Copy;
         pageRef.getParameters().put('reqlocation', selLocation);
         pageRef.getParameters().put('tableid', tableNumber);
         pageRef.setRedirect(true);
         return pageRef;
     }

     public PageReference backToCart(){
         PageReference pageRef = Page.Menu_Demo_Copy;
         pageRef.getParameters().put('reqlocation', selLocation);
         pageRef.getParameters().put('tableid', tableNumber);
         pageRef.setRedirect(true);
         return pageRef;
     }
         

    public PageReference rerenderPage() {
        return null;
    }
   


}