public class tablecontroller {

    public tablecontroller() {
	
    }
    public static String location = ApexPages.CurrentPage().getParameters().get('location');
    public static String tablename = ApexPages.CurrentPage().getParameters().get('tablename');
    public List<Displaytables> tables;
    public static String Ready='Ready';
    public static String Occupied='Occupied';
  
public List<Displaytables> gettables() {
 tables = new List<Displaytables>();
 for(Table__c t : [ SELECT  Name,Location__c,No_of_seats__c,Status__c,Table_Number__c FROM Table__c where Location__c=:'Indiana']) 
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
public void toready()
  { 
  }

public void tooccupied()
  { 
  }

}
}