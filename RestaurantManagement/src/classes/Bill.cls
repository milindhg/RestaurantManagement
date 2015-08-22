global class Bill{
    
    //velues fetched from query string
    public static String foodOrderId = ApexPages.currentPage().getParameters().get('orderId');
    public static String selLocation=ApexPages.currentPage().getParameters().get('reqlocation');
    public static String tableNumber=ApexPages.currentPage().getParameters().get('tableid');

    //fields for feedback
    public String SelectedFQ;
    public String SelectedService;
    public String SelectedOAE;
    public String likes;
    public String unlikes;
    public String tip;
  
    //get the entered food quality
    public String getSelectedFQ() {
        return SelectedFQ;
    }
     
    //set food quality
    public void setSelectedFQ(String recType) {
        this.SelectedFQ= recType;
    }
    
    //get the entered tip
     public String gettip() {
        return tip;
    }
     
    //set the value of tip
    public void settip(String recType) {
        this.tip= recType;
    }    
    
    //get the entered service rating
    public String getSelectedService() {
        return SelectedService;
    }
     
     //set the service rating    
    public void setSelectedService (String recType) {
        this.SelectedService= recType;
    }
    
    //get the overall experience rating
    public String getSelectedOAE () {
        return SelectedOAE;
    }
    
    //set the over all experience rating
    public void setSelectedOAE (String recType) {
        this.SelectedOAE = recType;
    }
    
    //get the value of likes
    public String getlikes() {
        
        return likes;
    }
     
    //get the value of likes
    public void setlikes(String recType) {
        this.likes= recType;
    }
    
    //get the values of unlikes
    public String getunlikes() {
        return unlikes;
    }
     
    //set the value of unlikes
    public void setunlikes(String recType) {
        this.unlikes= recType;
    }
     
    //parametrized constructor
    public Bill(String foodOrder){
        foodOrderId= foodOrder;
    }
    public Bill(){  
     
    }
    
    public List<DisplayCart> orderItemsList;
 
    public static final String PAID = 'Paid';
    
    //set the food order
    public Food_Order__c fo = getFoodOrder();
    
    //method to get the food order placed from the table
    public Food_Order__c getFoodOrder(){
      System.debug('Food Order ID'+foodOrderId);
     
      return  [SELECT f.Price__c, f.Tax__c, f.TotalPrice__c, f.FinalPrice__c,f.PriceEstimate__c, f.TaxEstimate__c, f.TotalPriceEstimate__c, f.TableNumber__c, f.SystemModstamp, 
                                         f.Status__c, f.OrderId__c, f.OrderDateTime__c,
                                         f.Name, f.LastModifiedDate, f.LastModifiedById, f.IsDeleted, f.Id, 
                                         f.DeliveryTime__c, f.CreatedDate, f.CreatedById 
              FROM Food_Order__c f
              WHERE f.Id =:foodOrderId];
        

    }
                            
    public Bill(ApexPages.StandardController controller) {}
    public Bill(ApexPages.StandardSetController controller) {}  
  
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
                                    o.Name, o.LastModifiedDate, 
                                    o.LastModifiedById, o.IsDeleted, o.Id, o.Food_Order__c, 
                                    o.Food_Item__c, o.CreatedDate, o.CreatedById, o.Tax__c 
                                    From Order_Item__c o
                                    where o.Food_order__c=:fo.id and o.Delete_Status__c <> 'Yes'
                                    order by o.Status__c]){
            if(item.Status__c != 'New'){
                    DisplayCart displayCart = new DisplayCart(item);
                    if(itemMap.containsKey(displayCart.foodItemId)){
                        DisplayCart cart = itemMap.get(displayCart.foodItemId);
                        Decimal quantity = cart.quantity;
                        quantity += item.Quantity__c;
                        cart.quantity = quantity;
                        cart.totalPrice += item.Total_Price__c;
                        itemMap.put(cart.foodItemId, cart);

                    }
                    else{                        
                       itemMap.put(displayCart.foodItemId, displayCart);
                    }
                }
        }
        for(DisplayCart displayCart: itemMap .values()){
            orderItemsList.add(displayCart);
            
           
            }
        
        return orderItemsList;
    }
    
    //method to add tip
    public void inserttip()
    {
         Food_Order__c foodOrder = [SELECT status__c, TotalPrice__c, FinalPrice__c,TableNumber__c, Tax__c, Name FROM Food_Order__c WHERE ID=:foodOrderId];
         if(String.isBlank(tip))
         { 
             foodOrder.Tip__c=0;}
        else{
         foodOrder.Tip__c =Decimal.valueOf(tip);}
         update foodOrder;
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
        finish();
    }
    
    //method to update the status of food order as PAID
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
            insert billItem;   
            
            PriceBook__c priceBook = [SELECT NoItemsOrdered__c FROM PriceBook__c WHERE ID=:displayCart.priceBook];
            priceBook.NoItemsOrdered__c += 1;
            update priceBook;  
                      
       }     
       
     }
     
     public PageReference finish(){
         PageReference pageRef = Page.testtables;
         pageRef.getParameters().put('reqlocation', selLocation);
         pageRef.getParameters().put('tableid', tableNumber);
         pageRef.setRedirect(true);
         return pageRef;
     }
    
    
     public PageReference backToCart(){
         PageReference pageRef = Page.Menu;
         pageRef.getParameters().put('reqlocation', selLocation);
         pageRef.getParameters().put('tableid', tableNumber);
         pageRef.setRedirect(true);
         return pageRef;
     }
         

    public PageReference rerenderPage() {
        return null;
    }
   


}