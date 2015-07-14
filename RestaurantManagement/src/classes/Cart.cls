/**
 * @author Milind Gokhale and Akshay Jarandikar
 * Creation Date: July 7, 2015
 * This class is the BackEnd Controller Class created for parallel development of MenuCart functionality,
 * This code is to be periodically integrated with the backend controller of Front end menu page. 
 */


global with sharing class Cart{


    public String foodOrderId = 'a0537000000RI9b';
    public Cart(){  }
    public List<DisplayCart> orderItemsList;
    public List<DisplayCart> activeCartItems;
    
    
    public static final String PAID = 'Paid';
    
    Food_Order__c fo = getFoodOrder();
    
    public Food_Order__c getFoodOrder(){
    return [Select f.Price__c, f.Tax__c, f.TotalPrice__c, f.PriceEstimate__c, f.TaxEstimate__c, f.TotalPriceEstimate__c, f.TableNumber__c, f.SystemModstamp, 
                        f.Status__c, f.OwnerId, f.OrderId__c, f.OrderDateTime__c, 
                        f.Name, f.LastViewedDate, f.LastReferencedDate, 
                        f.LastModifiedDate, f.LastModifiedById, f.IsDeleted, f.Id, 
                        f.DeliveryTime__c, f.CreatedDate, f.CreatedById 
                        From Food_Order__c f 
                        where f.id=:foodOrderId];
    }
                            
    public Cart(ApexPages.StandardController controller) {}
    public Cart(ApexPages.StandardSetController controller) {}  
  
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
                                    AND o.Delete_Status__c <> 'Yes'
                                    order by o.Status__c]){
            if(item.Status__c == 'Accepted' || item.Status__c == 'Picked Up' || item.Status__c == 'Ready' || item.Status__c == 'Pending')
                orderItemsList.add(new DisplayCart(item));
        }
        //fo = getFoodOrder();
        return orderItemsList;
    }
    
    //Method to get the active cart items - which are not accepted yet.
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
                                    where o.Food_order__c=:fo.id
                                    AND o.Delete_Status__c <> 'Yes']){
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
          orderItem.Delete_Status__c = 'Yes';
          update orderItem;                             
     }
     
     public void placeOrder() {
        String id= system.CurrentPageReference().getParameters().get('id');  
        Food_Order__c fo = [SELECT fo.Status__c FROM Food_Order__c fo where fo.id=: id];
        fo.Status__c = 'Pending';
        update fo;
        
        List<Order_Item__c> orderItems = [SELECT oi.Status__c FROM Order_Item__c oi where oi.Food_Order__c=:id AND oi.Status__c = 'New' AND oi.Delete_Status__c = 'No'];
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
        
        for(Order_Item__c o : orderItems){
            o.Delete_Status__c = 'Yes';            
        }
        
        update orderItems;                                                                 
     }

     public void paidStatusUpdate(){
         ID foodOrderId = ApexPages.CurrentPage().getParameters().get('foodOrderId');
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
     

     
     public Integer getCartSize(){
         return activeCartItems.size();
     }
    

}