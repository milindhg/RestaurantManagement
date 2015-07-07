global with sharing class Cart{
    public Id contactId = apexpages.currentpage().getparameters().get('id'); 
    Food_Order__c fo = [Select f.TotalPrice__c, f.TableNumber__c, f.SystemModstamp, f.Status__c, f.OwnerId, f.OrderId__c, f.OrderDateTime__c, f.Name, f.LastViewedDate, f.LastReferencedDate, f.LastModifiedDate, f.LastModifiedById, f.IsDeleted, f.Id, f.DeliveryTime__c, f.CreatedDate, f.CreatedById From Food_Order__c f
 where f.id='a0537000000RDjO'];
    List<DisplayCart> orderItemsList;
    public static Integer currentPage=1;
    
    public Cart(ApexPages.StandardController controller) {}
    public Cart(ApexPages.StandardSetController controller) {}  
  
    public List<DisplayCart> getCarts() {     
    orderItemsList = new List<DisplayCart>();
    
    
    if(orderItemsList == null) 
            orderItemsList = new List<DisplayCart>();
    else
        orderItemsList.clear();    
        
/*     for(Order_Item__c item : [SELECT Food_Item__c, Food_Order__c, Price__c, Quantity__c, Status__c, Total_Price__c
                                         FROM Order_Item__c
                                         WHERE Valid_Through__c >= :System.Today() ]) 
         deals.add(new DisplayDeal(item));

    
    
           List<Order_Item__c> items = */
            
         return orderItemsList;
    }
    
  
    
     public void onAdd() {
    
     }
       
     
     public void onRemove() {
   
     }
    
public class DisplayCart {

    private String dname;
    private Integer availableCarts;
    private Boolean acceptFlag = false;

    private String status;
    private String url;
    
    //public Id id = apexpages.currentpage().getparameters().get('id');
    public Id id = apexpages.currentpage().getparameters().get('id');
    public DisplayCart() {
            
        
  
    }
   
   public String getStatus() {
       return status;
   }
   
    public String getDname() {
        return dname;
    }
    
    public Integer getAvailableCarts() {
        return availableCarts;
    }       
      
    public Id getId() {
        return id;
    }  
   
    public String getUrl() {
        return url;
    }
  
}

}