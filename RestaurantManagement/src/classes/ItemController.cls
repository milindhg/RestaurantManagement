public class ItemController{
        private Food_Item__c item;
        private Decimal pricetag;
        private String imgurl;
        private PriceBook__c book;
        private Decimal numOfTimesOrdered;
        private String itemName;    
        
        public String getItemName(){
            return this.itemName;
        }
        
   public ItemController(){
           
        }
       
       public class Item{ 
        
         private Food_Item__c item;
        private Decimal pricetag;
        private String imgurl;
        private PriceBook__c book;
        private Decimal numOfTimesOrdered;
        
        
                
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