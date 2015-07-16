public class DisplayCart {
    private Order_Item__c cartItem;

    public DisplayCart(Order_Item__c item){
        this.cartItem = item;
        this.id = item.id;
        this.Name = item.Name;
        this.quantity = item.Quantity__c;
        this.totalPrice = item.Total_Price__c;
        this.status = item.Status__c;
        this.type = item.Type__c;
        this.tableNumber = item.table_number__c;
    }
    
    //public Id id = apexpages.currentpage().getparameters().get('id');
    //public Id id = apexpages.currentpage().getparameters().get('id');
    
    public Id id
    {
        get;
        set;
        
    }

    public String Name
    {
        get;
        set;
    }
    
/*    public Decimal price
    {
        //Code to get the price from the lookup column and return it here.
        get { return 10.00; }
        set;
    }
*/    
    public Decimal quantity
    {
        get;
        set;
    }

    public Decimal totalPrice
    {
        get; 
        set;
    }      

    public String status 
    {
        get;
        set;
        
    }
       
    public String type
    {
        get;
        set;
        
    }
    
    public Food_Item__c foodItem
    {
        get { return cartItem.Food_Item__r;}
    }
    
    public Id foodItemId
    {
        get { return cartItem.Food_Item__c;}
    }
    
    public Food_Order__c foodOrder
    {
        get { return cartItem.Food_Order__r; }
    }

    public Decimal tableNumber
    {
        //get { return cartItem.table_number__c; }
        get;
        set;
    }
}