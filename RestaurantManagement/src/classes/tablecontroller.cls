public class tablecontroller {
 public tablecontroller() {
  }
    public static String location;
    public static String tablename = ApexPages.CurrentPage().getParameters().get('tablename');
    public List<Displaytables> tables;
    public String selectedlocation;
    public String getselectedlocation() {
    return selectedlocation;
}

public void setselectedlocation(String recType) {
    this.selectedlocation= recType;
}
     public List<SelectOption> getLocationdata()
    {
               List<SelectOption> LocationList= new List<SelectOption>();
               for(Table__c t:[SELECT Name,Location__c,No_of_seats__c,Status__c,Table_Number__c FROM Table__c])
               {
                LocationList.add(new SelectOption(t.Location__c,t.Location__c));
               }
       
              return LocationList;
    }
    
public List<Displaytables> gettables()
{
 tables = new List<Displaytables>();
 System.debug('selectedlocation');
 for(Table__c t : [ SELECT  Name,Location__c,No_of_seats__c,Status__c,Table_Number__c FROM Table__c where Location__c=:location]) 
 {
 tables.add(new Displaytables(t));
 }    
return tables;
    
}
    
public PageReference getTable() {
    location = ApexPages.CurrentPage().getParameters().get('location');
    System.debug('selectedlocation');
    System.debug('location');
    return null;
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

    public void statuschange()
  {   }
}
}