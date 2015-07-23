public class DisplayOffer{
        private Offers__c availableOffers;
        private Decimal pricetag;
        private String imgurl;
        private PriceBook__c book;
        
        public DisplayOffer(Offers__c offer){
            this.availableOffers = offer;
            
        }
        
        public Integer getCount(){
            return 3;
        }
        
        public String name{
            get{return availableOffers.Food_Item__r.name;}
        }
        
        public Decimal discount{
            get{return availableOffers.discount__c;}
        }  
              
        public String description{
            get{return availableOffers.Description__c;}
        }
        
        public String getimgurl(){
           System.debug(imgurl);
           
           String s = availableOffers.Offer_Image__c+'';
           Integer st = s.indexOf('src');
           s = s.substring(st+5);
           Integer last = s.indexOf('\"');
           s = s.mid(0,last).replace('&amp;','&');
           imgurl = s;
           
           System.debug('Offer: '+imgurl);
           return imgurl;                       
                                
       }
        
       
        
}