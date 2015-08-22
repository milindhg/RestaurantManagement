//method to get the most popular items
public class DisplayMenuItems implements Comparable{
        private Food_Item__c item;
        private Decimal pricetag;
        private String imgurl;
        private String offerimgurl;
        private PriceBook__c book;
        private Decimal numOfTimesOrdered;
   
        
        public DisplayMenuItems(Food_Item__c item, List<PriceBook__c> price){
            this.item= item;
            this.pricetag= price[0].Price__c;
            this.book = price[0];
            this.numOfTimesOrdered = price[0].NoItemsOrdered__c;
            starredItem = false;
        }

		
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
        
         public String spiceLevel{
            get{return item.Spice_Level__c;}
        }
    
        public String typ{
            get{return item.Type__c;}
        }
        
        public Boolean starredItem{
            get;
            set;
        }
        
    //method to the image of the food items
        public String getimgurl(){
            String s = item.Item_Image__c+'';
            Integer st = s.indexOf('src');
            s = s.substring(st+5);
            Integer last = s.indexOf('\"');
            s = s.mid(0,last).replace('&amp;','&');
            imgurl = s;
            return imgurl; 
       }
       
    //get the image of offers
       public String getofferimgurl(){
           
           Id fitem_id = item.Id;
           System.debug('Item: '+fitem_id);
           
           Food_Item__c fitem = [SELECT Item_Image__c
                                 FROM Food_Item__c
                                 WHERE Id = :fitem_id];
                                 
           String s = fitem.Item_Image__c+'';
           Integer st = s.indexOf('src');
           s = s.substring(st+5);
           Integer last = s.indexOf('\"');
           s = s.mid(0,last).replace('&amp;','&');
           offerimgurl = s;
           
           System.debug('Offer: '+offerimgurl);
           return offerimgurl;                       
                                
       }
 
        public Decimal getNumOfTimesOrdered(){
            return this.numOfTimesOrdered;
        }
     
        public Integer compareTo(Object o){
            return (Integer)(((DisplayMenuItems)o).getNumOfTimesOrdered() - this.getNumOfTimesOrdered());
        }
     	/**
     	*variables:categoryLevelOne and categoryLevelTwo for custom category of food.
     	 Author:pankaj
     	*/
     	public String categoryLevelOne{get{return item.CategoryParentLevel__c;}}
     	public String categoryLevelTwo{get{return item.CategoryChildLevel__c;}}	
        
    }