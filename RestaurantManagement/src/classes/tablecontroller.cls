public class tablecontroller {
    public tablecontroller() {
    }
    public static String tablename = ApexPages.CurrentPage().getParameters().get('tablename');
    public List<Displaytables> tables;
    public String selectedlocation;
    public static String Occupied = 'Occupied';
    public static String Ready = 'Ready';
    
    public String getselectedlocation() {
        return selectedlocation;
    }
        public void setselectedlocation(String recType) {
        this.selectedlocation= recType;
    }
      public void updatestatus()
    {        
                 List<Table__c> tb= [SELECT Name,Status__c FROM Table__c where Name=:tablename];
             System.debug(tablename);
             for( Table__c t : tb )
             {if (t.Status__c=='Ready')
                {
                    t.Status__c='Occupied';                
                }
              else
                {
                    t.Status__c='Ready';              
                }
             update tb;}
        }
    
    public List<SelectOption> getLocationdata()
    {                   
        List<Table__c> tb= [Select f.Location__c from Table__c f];
        
        Map<String,String> mp = new Map<String,String>();
        Integer count=1;
        for(Table__c loc:tb){
            mp.put(loc.Location__c,loc.Location__c);
            count++;            
        }
        List<SelectOption> LocationList= new List<SelectOption>();
        LocationList.add(new SelectOption('Select','Select'));
        for(String key: mp.keySet()){
            
            LocationList.add(new SelectOption(mp.get(key),mp.get(key)));
            
        }
       
        return LocationList;
    }
    
    public List<Displaytables> gettables()
    {
        tables = new List<Displaytables>();
        System.debug(selectedlocation);
        for(Table__c t : [ SELECT  Name,Location__c,No_of_seats__c,Status__c,Table_Number__c FROM Table__c where Location__c=:selectedlocation ORDER BY No_of_seats__c ]) 
        {
            tables.add(new Displaytables(t));
        }    
        return tables;
        
    }    

    public class Displaytables {
        private Table__c table;
        public Displaytables(Table__c t) {
            this.table = t;
        }
        public String name {
            get { return table.Name; }
        }
        public String Locations {
            get { return table.Location__c; }
        }
        public String Status {
            get { return table.Status__c; }
        }
        public Integer Seats {
            get { return table.No_of_seats__c.intValue(); }
        }  
        public String TableNumber {
            get { return table.Table_Number__c; }
        }
              }
}