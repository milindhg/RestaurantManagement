global with sharing class Bill{

    public String foodOrderId = 'a0537000000RI9b';
    
    public String SelectedFQ;
    public String SelectedService;
    public String SelectedOAE;
    public String likes;
    public String unlikes;
    
    public String getSelectedFQ() {
        return SelectedFQ;
    }
     
    public void setSelectedFQ(String recType) {
        this.SelectedFQ= recType;
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
   
   
    
    
    public Bill(){  }
    public List<DisplayCart> orderItemsList;
 
    public static final String PAID = 'Paid';
    
    Food_Order__c fo = getFoodOrder();
    
    public Food_Order__c getFoodOrder(){
    return [SELECT f.Price__c, f.Tax__c, f.TotalPrice__c, f.PriceEstimate__c, f.TaxEstimate__c, f.TotalPriceEstimate__c, f.TableNumber__c, f.SystemModstamp, 
                        f.Status__c, f.OwnerId, f.OrderId__c, f.OrderDateTime__c,
                        f.Name, f.LastViewedDate, f.LastReferencedDate, 
                        f.LastModifiedDate, f.LastModifiedById, f.IsDeleted, f.Id, 
                        f.DeliveryTime__c, f.CreatedDate, f.CreatedById 
                        From Food_Order__c f 
                        where f.id=:foodOrderId];
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
                                    o.Name, o.LastViewedDate, o.LastReferencedDate, o.LastModifiedDate, 
                                    o.LastModifiedById, o.IsDeleted, o.Id, o.Food_Order__c, 
                                    o.Food_Item__c, o.CreatedDate, o.CreatedById 
                                    From Order_Item__c o
                                    where o.Food_order__c=:fo.id
                                    order by o.Status__c]){
            if(item.Status__c == 'Accepted' || item.Status__c == 'Picked Up' || item.Status__c == 'Ready' || item.Status__c == 'Pending'){
                    DisplayCart displayCart = new DisplayCart(item);
                    System.debug('Map-----------------------------------');
                    System.debug(itemMap);
                    System.debug('Cart-----------------------------------');
                    System.debug(displayCart);
                    System.debug('-----------------------------------');
                    if(itemMap.containsKey(displayCart.foodItemId)){
                        DisplayCart cart = itemMap.get(displayCart.foodItemId);
                        cart.quantity += item.Quantity__c;
                        cart.totalPrice += item.Total_Price__c;
                        System.debug('Updated Cart-----------------------------------');
                        System.debug(cart);
                        itemMap.put(displayCart.foodItemId, cart);
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
    
     public void insertfeedback()
    {
    Feedback__c fb = new Feedback__c();
    fb.Food_Quality__c=SelectedFQ;
    fb.Overall_Experience__c=SelectedOAE;
    fb.Service__c=SelectedService;
    fb.What_I_liked__c=likes;
    fb.What_must_have_been_there__c=unlikes;
    insert fb;
    likes=null;
    unlikes=null;
    SelectedFQ='5';
    SelectedOAE='5';
    SelectedService='5';
    }
    
     public PageReference paidStatusUpdate(){
         Food_Order__c foodOrder = [SELECT status__c FROM Food_Order__c WHERE ID=:foodOrderId];
         foodOrder.status__c = PAID;
         update foodOrder;
         PageReference pageRef = Page.MenuCart;
         pageRef.setRedirect(true);
         return pageRef;
     }

     public PageReference backToCart(){
         PageReference pageRef = Page.MenuCart;
         pageRef.setRedirect(true);
         return pageRef;
     }
         
    


}