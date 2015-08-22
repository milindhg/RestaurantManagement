@isTest
public class TestDataFactory {
    
    public static Restaurant__c createRestaurant(){

        Restaurant__c resto = new Restaurant__c();
        resto.Name= 'Chipotle';
        resto.Apartment_Suite__c='125';
        resto.Branch__c='Tuttle';
        resto.City__c='Dublin';
        resto.Country__c='United States';
        resto.Email__c='chipotle@chipotle.com';
        resto.Manager__c='Lannister';
        resto.Phone__c='8888888888';
        resto.State__c='Ohio';
        resto.Street_Address__c='Tuttle Crossing Blvd';
        resto.Zip__c='99999';

        
        return resto;

    }
    
    public static Table__c createTable(Restaurant__c resto){
  
        Table__c table = new Table__c(No_of_seats__c = 5,
                                     Restaurant_Branch__c = resto.Id,
                                     Status__c='Ready',
                                     Table_Number__c='3',
                                     Waiter__c = 'Waiter'); 
        
        return table;

    }
    
    public static Food_Item__c createFoodItem(Restaurant__c resto){
        Food_Item__c item= new Food_Item__c(Calories__c=100,
                                            status__c = 'enabled',
                                            Category__c='Appetizer',
                                            Description__c='Test Food Item',
                                            Type__c='Vegan',
                                            Name='Test',
                                            Special__c=True,
                                            Prep_Time__c = 20,
                                            Spice_level__c = 'Medium');
        
        createOffer(item);
        createPriceBook(resto, item);
        
         return item;
    }
    
    public static Food_Order__c createFoodOrder(Restaurant__c resto, Decimal table_no, Food_Item__c food_item, 
                                                PriceBook__c pbook){                                        
        Food_Order__c forder = new Food_Order__c(Name = 'Test Food Order',
                                                Restaurant_Branch__c=resto.Id,
                                                TableNumber__c=table_no,
                                                Status__c = 'New');
        return forder;
    }
    public static Order_Item__c createOrderitem(Restaurant__c resto, Food_Order__c food_order, Food_Item__c food_item,
                                                PriceBook__c pbook){                                          
        Order_Item__c orderitem= new Order_Item__c(Name ='Test Order Item',
                                                    Category__c='Vegan',
                                                    Price__c = pbook.Id,
                                                    Food_Item__c = food_item.Id,
                                                    Food_Order__c= food_order.Id,
                                                    Quantity__c=2,
                                                    Restaurant_Id__c= resto.Restaurant_Id__c,
                                                    Status__c= 'New');

        return orderitem;
    }
    
    public static Chef__c createChef(Restaurant__c resto){
        Chef__c chef = new Chef__c(Total_Chefs__c=5,
                                   Restaurant_Id__c= resto.Id);
        return chef;
    }
    
    public static PriceBook__c createPriceBook(Restaurant__c resto, Food_Item__c fitem){
        PriceBook__c pbook = new PriceBook__c (Name = 'Test Price Book',
                                               Price__c=6,
                                               Food_Item__c= fitem.Id,
                                               Restaurant_Branch__c= resto.Id);

        return pbook;
    }
    
    public static RawMaterial__c  createRawMaterial(Restaurant__c resto){
        RawMaterial__c material = new RawMaterial__c();
        material.Name ='Test Raw Material';
        //material.Name__c='Test Raw Material';
        material.Restaurant__c= resto.Id;
        material.threshold__c=4;
        material.Used_till_now__c=4;
        material.Used__c=2;
        
        insert material;
        createPurchase(material);
        
        return material;
    }
    
    public static Purchase__c createPurchase(RawMaterial__c rawmat){
        Purchase__c purchase= new Purchase__c();
        purchase.Price__c=20;
        purchase.Quantity__c=12;
        purchase.RawMaterial__c= rawmat.Id;
        purchase.Date_of_Purchase__c=System.today();
        insert purchase;
        return purchase;
    }
    
    public static Offers__c createOffer(Food_Item__c fitem){
        Offers__c offer = new Offers__c();
        offer.Description__c='Discount';
        offer.Discount__c=10;
        offer.Food_Item__c= fitem.Id;
        
        insert offer;
        return offer;
    }
}