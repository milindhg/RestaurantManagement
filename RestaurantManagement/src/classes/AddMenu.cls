global with sharing class AddMenu{

      
    public String itemName;
    public List<String> locations = fetchLocations();
    public String location{get ; set;}

    public AddMenu(){  }
    
    public List<String> getLocations(){
        return locations;
    }
 
//   locations = fetchLocations();
     
    public List<String> fetchLocations(){
        List<String> listLocations = new List<String>();
        for(Restaurant__c r : [SELECT r.Branch__c From Restaurant__c r ]){
            listLocations.add(r.Branch__c);
        }
        return listLocations;
        
    }
    
     public List<SelectOption> getLocationdata()
    {                   
        List<Restaurant__c> tb= [SELECT r.Branch__c From Restaurant__c r ];
        
        Map<String,String> mp = new Map<String,String>();
        Integer count=1;
        for(Restaurant__c loc:tb){
            mp.put(loc.Branch__c ,loc.Branch__c);
            count++;            
        }
        List<SelectOption> LocationList= new List<SelectOption>();

        for(String key: mp.keySet()){
            
            LocationList.add(new SelectOption(mp.get(key),mp.get(key)));
            
        }
       
        return LocationList;
    }
    
    
    
    
    
                            
    public AddMenu(ApexPages.StandardController controller) {}
    public AddMenu(ApexPages.StandardSetController controller) {}  
  
    
}