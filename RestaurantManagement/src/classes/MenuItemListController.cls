global class MenuItemListController {
    
    
    
    public static List<DisplayMenuItems> ItemList;
    //public static String location=ApexPages.currentPage().getParameters().get('reqlocation');
    public static String Location='Ohio';
    public static String table=ApexPages.currentPage().getParameters().get('tableid');
    
    public List<DisplayMenuItems> getMenuItems(){
        
        if(ItemList==null){
            
            ItemList = new List<DisplayMenuItems>();
            for(Food_Item__c item : [Select Name, Category__c, Description__c,Diet__c, Prep_Time__c,Status__c,Type__c  From Food_Item__c where Status__c='enabled' ]){
                ItemList.add(new DisplayMenuItems(item));
            }
        }
        
        return ItemList;
    }
    
    @RemoteAction 
    WebService static String createOrderItem(String item, String quant){
        Decimal tableid= Decimal.valueOf(table);
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
        orderitem.Food_Item__c= food_items[0].Id;
        orderitem.Food_Order__c= orders[0].Id;
        orderitem.Quantity__c= decimal.valueOf(quant);
        orderitem.Status__c='New';
        insert orderitem;
        return orders[0].name;
        
    }
    
    
    
    public class DisplayMenuItems{
        private Food_Item__c availableItems;
        
        
        public DisplayMenuItems(Food_Item__c item){
            this.availableItems= item;
            
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
        
        public String category{
            get{return availableItems.Category__c;}
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
        
        public String typ{
            get{return availableItems.Type__c;}
        }
        
         public Object diet{
            get{return availableItems.Diet__c;}
        }
        
    }
}