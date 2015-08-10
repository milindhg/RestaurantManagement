public class tablecontroller {
    public tablecontroller() {
    }
    public static String tablename = ApexPages.CurrentPage().getParameters().get('tablename');
   public static String uid;
    public List<Displaytables> tables;
  //  public String selectedstate;
  //  public String selectedbranch;
  //  public String selectedcity;
    public static String Occupied = 'Occupied';
    public static String Ready = 'Ready';
//    public String branchid;
    
    public String userRestoId {get;set;}
    
  
    //public String getbranchid() {
      //  List<Table__c> tb=[SELECT Restaurant_Branch__r.Restaurant_ID__c FROM Table__c where 
        // Restaurant_Branch__r.Branch__c=:selectedbranch];
        // for (Table__c t:tb)
        //{      branchid = t.Restaurant_Branch__r.Restaurant_ID__c;
         //}
    
     //return branchid;
           // }
    
    //public String getselectedstate() {
      //  return selectedstate;
    //}
        //public void setselectedstate(String recType) {
       // this.selectedstate= recType;
   // }
   // public String getselectedcity() {
     //   return selectedcity;
    //}
      //  public void setselectedcity(String recType) {
        //this.selectedcity= recType;
    //}
    
    //public String getselectedbranch() {
      //  return selectedbranch;
    //}
   //    public void setselectedbranch(String recType) {
     //   this.selectedbranch= recType;
    //}
    
     public static String getRestoId(){
       User u  = [SELECT Restaurant_Id__c
                  FROM   User
                  WHERE  Id = :UserInfo.getUserId()];
           
       String rid = u.Restaurant_Id__c;
       
       return rid;
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
    
   /* public List<SelectOption> getStatedata()
    {                   
        List<Table__c> tb= [Select  f.Restaurant_Branch__r.State__c from Table__c f];
        
       Map<String,String> mp = new Map<String,String>();
        Integer count=1;
        for(Table__c loc:tb){
            mp.put(loc.Restaurant_Branch__r.State__c,loc.Restaurant_Branch__r.State__c);
            count++;            
        }
        List<SelectOption> LocationList= new List<SelectOption>();
        LocationList.add(new SelectOption('Select','Select'));
        for(String key: mp.keySet()){
            
            LocationList.add(new SelectOption(mp.get(key),mp.get(key)));
            
        }
       
        return LocationList;
    }
    
    
    public List<SelectOption> getBranchdata()
    {                   
        List<Table__c> tb= [Select f.Restaurant_Branch__r.Branch__c from Table__c f where f.Restaurant_Branch__r.City__c=:selectedcity];
        Map<String,String> mp = new Map<String,String>();
        Integer count=1;
        for(Table__c loc:tb){
            mp.put(loc.Restaurant_Branch__r.Branch__c,loc.Restaurant_Branch__r.Branch__c);
            count++;            
        }
        List<SelectOption> BranchList= new List<SelectOption>();
        BranchList.add(new SelectOption('Select','Select'));
        for(String key: mp.keySet()){
        BranchList.add(new SelectOption(mp.get(key),mp.get(key)));
        }
       
        return BranchList;
    }
    
    
    public List<SelectOption> getCitydata()
    {                   
        
      //  System.debug(selectedstate);
        List<Table__c> tb= [Select f.Restaurant_Branch__r.City__c from Table__c f where f.Restaurant_Branch__r.State__c=:selectedstate];
        
        Map<String,String> mp = new Map<String,String>();
        Integer count=1;
        for(Table__c cit:tb){
            mp.put(cit.Restaurant_Branch__r.City__c ,cit.Restaurant_Branch__r.City__c );
            count++;            
        }
        List<SelectOption> CityList= new List<SelectOption>();
        CityList.add(new SelectOption('Select','Select'));
        for(String key: mp.keySet()){
        CityList.add(new SelectOption(mp.get(key),mp.get(key)));
        }
       
        return CityList;
    }
    */
    public PageReference tomenu() 
    {
         PageReference pageRef = Page.Menu;
           System.debug(uid);
           System.debug(tablename);
         pageRef.getParameters().put('reqlocation',uid);
         pageRef.getParameters().put('&tableid',tablename);
         pageRef.setRedirect(true);
         return pageRef;
    }
    
    public List<Displaytables> gettables()
    {
         uid = tablecontroller.getRestoId();
         tables = new List<Displaytables>();
       
          for(Table__c t : [ SELECT  Name,Location__c,No_of_seats__c,Status__c,Table_Number__c,Restaurant_Branch__r.Restaurant_ID__c,Restaurant_Branch__r.Branch__c FROM Table__c where 
          Restaurant_Branch__r.Restaurant_ID__c=:uid ORDER BY No_of_seats__c ]) 
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
        public String urid {
            get { return uid; }
        }
        public String waiter {
            get { return table.Waiter__c; }
        }
        
       }
}