public class tablecontroller {

    public static String location = ApexPages.CurrentPage().getParameters().get('location');
	List<Displaytables> tables;
    public static String Ready='Ready';
    public static String Occupied='Occupied';
    public static String tablename = ApexPages.CurrentPage().getParameters().get('tablename');
    public tablecontroller(ApexPages.StandardController controller) {
}
   


    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [select Name from Table__c]));
            }
            return setCon;
        }
        set;
    }
    

public List<Displaytables> gettables() {

tables = new List<Displaytables>();
for(Table__c t : [
SELECT  Name,Location__c,No_of_seats__c,Status__c,Table_Number__c FROM Table__c ]) {
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
     public void toready()
  {  Table__c  t = new Table__c();
     t.Status__c = Ready;
      update t;
  }
    
public void tooccupied()
  {  Table__c  t = new Table__c();
   
     t.Status__c = Occupied;
      update t;
  }
}
}