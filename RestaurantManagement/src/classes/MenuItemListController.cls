public class MenuItemListController {
    
    
    
    public static List<DisplayMenuItems> ItemList;
    
    public List<DisplayMenuItems> getMenuItems(){
        
        if(ItemList==null){
            
            ItemList = new List<DisplayMenuItems>();
            for(Food_Item__c item : [Select Name, Category__c, Description__c,Prep_Time__c,Status__c,Type__c   From Food_Item__c]){
                ItemList.add(new DisplayMenuItems(item));
            }
        }
        
        return ItemList;
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
        
    }
}