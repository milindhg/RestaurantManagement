public with sharing class tablecontroller {
    public tablecontroller() {
    }
    public static String tablename = ApexPages.CurrentPage().getParameters().get('tablename');
    public static String uid;
    public List<Displaytables> tables;
    public static String Occupied = 'Occupied';
    public static String Ready = 'Ready';
    public String userRestoId {get;set;}
  
    // Getting restaurant ID of the user logged in.
     public static String getRestoId(){
       User u  = [SELECT Restaurant_Id__c
                  FROM   User
                  WHERE  Id = :UserInfo.getUserId()];
           
       String rid = u.Restaurant_Id__c;
       
       return rid;
    }
    
    // Changing status of the tables from ready to occupied or vice versa.
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

    // Getting records from tables object.
    public List<Displaytables> gettables()
    {
         uid = tablecontroller.getRestoId();
         tables = new List<Displaytables>();
       
          for(Table__c t : [ SELECT  Name,No_of_seats__c,Status__c,Table_Number__c,Restaurant_Branch__r.Restaurant_ID__c,Restaurant_Branch__r.Branch__c FROM Table__c where 
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