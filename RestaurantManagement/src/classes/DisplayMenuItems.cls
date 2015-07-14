public class DisplayMenuItems implements Comparable{
        private Food_Item__c item;
        private Decimal pricetag;
        private String imgurl;
        private PriceBook__c book;
        private Decimal numOfTimesOrdered;
   
        
        public DisplayMenuItems(Food_Item__c item, List<PriceBook__c> price){
            this.item= item;
            this.pricetag= price[0].Price__c;
            this.book = price[0];
            this.numOfTimesOrdered = price[0].NoItemsOrdered__c;
            starredItem = false;
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
            get{return item.Name;}
        }
        
        public Id priceBook{
            get{return this.book.Id;}
        }
        
        public String category{
            get{return item.Category__c;}
        }
                
                public Decimal price{
            get{return this.pricetag;}
        }        
        public String description{
            get{return item.Description__c;}
        }
        
        public Decimal preptime{
            get{return item.Prep_Time__c;}
        }
        
    	public Decimal calories{
            get{return item.Calories__c;}
        }
    
        public String status{
            get{return item.Status__c;}
        }
        
        public boolean isSpecial{
            get{return item.Special__c;}
        }
        public String typ{
            get{return item.Type__c;}
        }
        
        public Boolean starredItem{
            get;
            set;
        }
        
        public String getimgurl(){
           imgurl = item.Item_Image__c+'';
           Integer st_index = imgurl.IndexOf('src');
           Integer end_index = imgurl.lastIndexOf('\"');
           
           Integer len = end_index - (st_index+5);
           imgurl = imgurl.mid(st_index+5,len).replace('&amp;','&');
           return imgurl; 
       }
        
        // public Object diet{
          //  get{return item.Diet__c;}
        //}
     
        public Decimal getNumOfTimesOrdered(){
            return this.numOfTimesOrdered;
        }
     
        public Integer compareTo(Object o){
            return (Integer)(((DisplayMenuItems)o).getNumOfTimesOrdered() - this.getNumOfTimesOrdered());
        }
     
        
    }