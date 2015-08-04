@isTest
public class TestDataFactory {
    
    //public static String Restaurant_Id;
    //public static String Food_Order_Id;
    //public static String Table_Id;
    //public static String Chef_Id;
    //public static String Food_Item_Id;
    //public static String Food_Order_Item_Id;
    //public static String Inventory_Id;
    //public static String Raw_Material_Id;
    //public static String Price_Book_Id;
    //public static String Purchase_Id;
    //public static String Offers_Id;
    
    public static Restaurant__c createRestaurant(){
        
        Restaurant__c rest = new Restaurant__c();
        rest.Name= 'Chipotle';
        rest.Apartment_Suite__c='125';
        rest.Branch__c='Tuttle';
        rest.City__c='Dublin';
        rest.Country__c='United States';
        rest.Email__c='chipotle@chipotle.com';
        rest.Manager__c='Lannister';
        rest.Phone__c='8888888888';
        //rest.Restaurant_ID__c='R-9999';
        rest.State__c='Ohio';
        rest.Street_Address__c='Tuttle Crossing Blvd';
        rest.Zip__c='99999';
        //Restaurant_Id= rest.Id;
        insert rest;
        return rest;
        
    }
    
    public static Table__c createTable(){
        Table__c table = new Table__c();
        table.No_of_seats__c=5;
        table.Restaurant_Branch__c=createRestaurant().Id;
        table.Status__c='Ready';
        table.Table_Number__c='3';
        table.Waiter__c='Waiter';
        //Table_Id= table.Id;
        insert table;
        return table;
    }
    
    public static Food_Item__c createFoodItem(){
        Food_Item__c item= new Food_Item__c();
        item.Calories__c=100;
        item.Category__c='Appetizer';
        item.Description__c='Test Food Item';
        item.Type__c='Vegan';
        item.Name='Test';
        //Food_Item_Id= item.Id;
        return item;
    }
	
    public static Food_Order__c createFoodOrder(){
        Food_Order__c order= new Food_Order__c();
       	order.Restaurant_Branch__c=createRestaurant().Id;
        order.TableNumber__c=Decimal.valueOf(createTable().Table_Number__c);
        return order;
    }
    public static Order_Item__c createOrderitem(){
        Order_Item__c orderitem= new Order_Item__c();
		//orderitem.Type__c='Appetizer';
		orderitem.Category__c='Vegan';
        Food_Item__c item = createFoodItem();
        Food_Order__c order = createFoodOrder();
		orderitem.Food_Item__c = item.Id;
        orderitem.Food_Order__c= order.Id;
        orderitem.Quantity__c=2;
        orderitem.Restaurant_Id__c= createRestaurant().Id;
        orderitem.Status__c= 'New';
        return orderitem;
    }
    
    public static Chef__c createChef(){
        Chef__c chef = new Chef__c();
        chef.Total_Chefs__c=5;
        chef.Restaurant_Id__c= createRestaurant().Id;
        return chef;
    }
    
    public static RawMaterial__c  createRawMaterial(){
        RawMaterial__c  material = new RawMaterial__c ();
        material.Name__c='Test';
        material.Restaurant__c= createRestaurant().Id;
        material.threshold__c=4;
        material.Used__c=2;
        return material;
    }
    
    public PriceBook__c createPriceBook(){
        PriceBook__c pricebook = new PriceBook__c ();
        pricebook.Price__c=6;
        pricebook.Food_Item__c= createFoodItem().Id;
        pricebook.Restaurant_Branch__c= createRestaurant().Id;
        return pricebook;
    }
    
    public Purchase__c createPurchase(){
        Purchase__c purchase= new Purchase__c();
        purchase.Price__c=20;
        purchase.Quantity__c=12;
        purchase.RawMaterial__c= createRawMaterial().Id;
        return purchase;
    }
    
    public Offers__c createOffer(){
        Offers__c offer = new Offers__c();
        offer.Description__c='Discount';
        offer.Food_Item__c= createFoodItem().Id;
        return offer;
    }
}