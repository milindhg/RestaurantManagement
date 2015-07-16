public class DisplayCart {
    private Order_Item__c cartItem;

    public DisplayCart(Order_Item__c item){
        this.cartItem = item;
    }
    
    //public Id id = apexpages.currentpage().getparameters().get('id');
    //public Id id = apexpages.currentpage().getparameters().get('id');
    
    public Id id
    {
        get { return cartItem.id; }
        
    }

    public String Name
    {
        get { return cartItem.name;  }
        set;
    }
    
    public Decimal price
    {
        //Code to get the price from the lookup column and return it here.
        get { return 10.00; }
        set;
    }
    
    public Decimal quantity
    {
        get { return cartItem.Quantity__c; }
        set;
    }

    public Decimal totalPrice
    {
        get { return cartItem.Total_Price__c; } 
        set;
    }      

    public String status 
    {
        get { return cartItem.status__c; }
        
    }
       
    public String type
    {
        get { return cartItem.type__c; }
        
    }
    
    public Food_Item__c foodItem
    {
        get { return cartItem.Food_Item__r;}
        set;
    }
    
    public Id foodItemId
    {
        get { return cartItem.Food_Item__c;}
        set;
    }
    
    public Food_Order__c foodOrder
    {
        get { return cartItem.Food_Order__r; }
    }

    public Decimal tableNumber
    {
        get { return cartItem.table_number__c; }
        set;
    }
}