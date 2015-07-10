global with sharing class Bill{

    public String foodOrderId = 'a0537000000RI9b';
    public Bill(){  }
    public List<DisplayCart> orderItemsList;
 
    public static final String PAID = 'Paid';
    
    Food_Order__c fo = getFoodOrder();
    
    public Food_Order__c getFoodOrder(){
    return [Select f.TotalPrice__c, f.TotalPriceEstimate__c, f.TableNumber__c, f.SystemModstamp, 
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