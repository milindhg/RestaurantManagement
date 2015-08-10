global with sharing class AddMenu{
      
    public String itemName{get; set;}
    public Decimal calories{get; set;}
    public String description{get; set;} 
    public String category{get; set;} 
    public Decimal prepTime{get; set;}
    public String Photo{get;set;}
    public string photoname{get;set;}
    public string photourl{get;set;}
    public string type{get;set;}
    public string spicy{get;set;}
    public blob tempBlob {get; set;}
   
    public List<String> locations = fetchLocations();
    public List<String> location{get ; set;}

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
    
    public PageReference displayName(){
        System.debug('ItemName--->' + itemName);
        return null;
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
  
    public PageReference rerenderPage() {
        return null;
    }
      
    public PageReference saveItem() {
        System.debug('*****' + itemName + '*****' + category + '*****' + calories + '***** ' + description + '***** ' + prepTime);
        
        String b64;
        String strUrlUTF8;
        String strOriginal;
        String b;
        
 /*       
        b64 = EncodingUtil.base64Encode(tempBlob);
        System.debug('String b64: [' + b64 + ']');
        
        b = EncodingUtil.base64Decode(b64);
        System.debug('Blob b: [' + b.toString() + ']');
        
        strUrlUTF8 = b.toString();
        System.debug('String strUrlUTF8: [' + strUrlUTF8 + ']');
        
        strOriginal = EncodingUtil.urlDecode(strUrlUTF8, 'UTF-8');
        System.debug('String strOriginal: [' + strOriginal + ']');
  */      
        
        
        String hex = EncodingUtil.convertToHex(tempBlob);
    System.assertEquals(0, hex.length() & 1);
    final Integer bytesCount = hex.length() >> 1;
    String[] bytes = new String[bytesCount];
    for(Integer i = 0; i < bytesCount; ++i)
        bytes[i] =  hex.mid(i << 1, 2);
    String temp =  EncodingUtil.urlDecode('%' + String.join(bytes, '%'), 'ISO 8859-2');
        
        
        Food_Item__c item = new Food_Item__c();
        item.Calories__c = calories;
        item.Description__c = description;
        item.Prep_Time__c = prepTime;
        item.Name = itemName;
        item.Category__c = category;
        item.Type__c = type;
        item.Spice_Level__c = spicy;
        item.Item_Image__c = temp ;
        insert item;
        return null;
    }
   
}