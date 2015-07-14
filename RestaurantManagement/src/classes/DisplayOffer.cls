global class DisplayOffer{
        private Offers__c availableOffers;
        private Decimal pricetag;
        private String imgurl;
        private PriceBook__c book;
        
        
        public Integer getCount(){
            return 3;
        }
        
        public DisplayOffer(Offers__c offer){
            this.availableOffers= offer;
            
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
        
       
        
}