@isTest
public class TestDataFactory {
    
    public static Restaurant__c createRestaurant(){
        //try{
        Restaurant__c resto = new Restaurant__c();
        resto.Name= 'Chipotle';
        resto.Apartment_Suite__c='125';
        resto.Branch__c='Tuttle';
        resto.City__c='Dublin';
        resto.Country__c='United States';
        resto.Email__c='chipotle@chipotle.com';
        resto.Manager__c='Lannister';
        resto.Phone__c='8888888888';
        //resto.Restaurant_ID__c='R-9999';
        resto.State__c='Ohio';
        resto.Street_Address__c='Tuttle Crossing Blvd';
        resto.Zip__c='99999';
        
        //insert resto;
        
        //Table__c t = createTable(resto);
        //Food_Item__c food_item = createFoodItem(resto);
        //PriceBook__c pbook = createPriceBook(resto, food_item);
        //createFoodOrder(resto, Decimal.valueOf(t.Table_Number__c), food_item, pbook);
        //createChef(resto);
        //createRawMaterial(resto);
        
        return resto;
        //}
       // catch(Exception e){
       //     System.debug('In createRestaurant: '+e.getMessage());
       //  return null;
      //  }
    }
    
    public static Table__c createTable(Restaurant__c resto){
       // try{
        Table__c table = new Table__c(No_of_seats__c = 5,
                                     Restaurant_Branch__c = resto.Id,
                                     Status__c='Ready',
                                     Table_Number__c='3',
                                     Waiter__c = 'Waiter'); 
        
        return table;
        //}
       // catch(Exception e){
       //     System.debug('In createTable: '+e.getMessage());
       //  return null; 
       // }
    }
    
    public static Food_Item__c createFoodItem(Restaurant__c resto){
        //try{
        Food_Item__c item= new Food_Item__c(Calories__c=100,
                                            Category__c='Appetizer',
                                            Description__c='Test Food Item',
                                            Type__c='Vegan',
                                            Name='Test',
                                            Prep_Time__c = 20,
                                            Spice_level__c = 'Medium');
        
        createOffer(item);
        createPriceBook(resto, item);
        
         return item;
        //}
       // catch(Exception e)
       // {System.debug('In createFoodItem: '+e.getMessage());
       //  return null;   
       // }
    }
	
    public static Food_Order__c createFoodOrder(Restaurant__c resto, Decimal table_no, Food_Item__c food_item, 
                                                PriceBook__c pbook){
        
       //try{                                            
        Food_Order__c forder = new Food_Order__c(Name = 'Test Food Order',
       											Restaurant_Branch__c=resto.Id,
        										TableNumber__c=table_no,
        										Status__c = 'New');
        
        //createOrderitem(resto, forder, food_item, pbook);
        return forder;
       //}
      
      //catch(Exception e){
      //   System.debug('In createFoodOrder: '+e.getMessage());
      //   return null;   
      //}
    }
    public static Order_Item__c createOrderitem(Restaurant__c resto, Food_Order__c food_order, Food_Item__c food_item,
                                                PriceBook__c pbook){
        
      // try{                                            
        Order_Item__c orderitem= new Order_Item__c(Name ='Test Order Item',
                                                    Category__c='Vegan',
                                                    Price__c = pbook.Id,
                                                    Food_Item__c = food_item.Id,
                                                    Food_Order__c= food_order.Id,
                                                    Quantity__c=2,
                                                    Restaurant_Id__c= resto.Restaurant_Id__c,
                                                    Status__c= 'New');

        return orderitem;
      // }
      // catch(Exception e)
      // {System.debug('In createOrderitem: '+e.getMessage());
      //   return null;
      // }
    }
    
    public static Chef__c createChef(Restaurant__c resto){
       // try{
        Chef__c chef = new Chef__c(Total_Chefs__c=5,
        						   Restaurant_Id__c= resto.Id);
        
        //insert chef;
        return chef;
       // }
       // catch(Exception e)
       // {
      //   System.debug('In createChef: '+e.getMessage());
       //  return null;
       // }
    }
    
    public static PriceBook__c createPriceBook(Restaurant__c resto, Food_Item__c fitem){
       // try{
        PriceBook__c pbook = new PriceBook__c (Name = 'Test Price Book',
                                               Price__c=6,
                                               Food_Item__c= fitem.Id,
                                               Restaurant_Branch__c= resto.Id);

        return pbook;
       // }
       // catch(Exception e){
       //  System.debug('In createPriceBook: '+e.getMessage());
       //  return null;
       // }
    }
    
    public static RawMaterial__c  createRawMaterial(Restaurant__c resto){
        //try{
        RawMaterial__c material = new RawMaterial__c();
        material.Name ='Test Raw Material';
        material.Name__c='Test Raw Material';
        material.Restaurant__c= resto.Id;
        material.threshold__c=4;
        material.Used__c=2;
        
        insert material;
        createPurchase(material);
        
        return material;
       // }
       // catch(Exception e)
       // { System.debug('In createRawMaterial: '+e.getMessage());
       //  return null;
            
       // }
    }
    
    public static Purchase__c createPurchase(RawMaterial__c rawmat){
       // try{
        Purchase__c purchase= new Purchase__c();
        purchase.Price__c=20;
        purchase.Quantity__c=12;
        purchase.RawMaterial__c= rawmat.Id;
        
        insert purchase;
        return purchase;
       // }
       // catch(Exception e){
       //     System.debug('In createPurchase: '+e.getMessage());
       //  return null;
       // }
    }
    
    public static Offers__c createOffer(Food_Item__c fitem){
       // try{
        Offers__c offer = new Offers__c();
        offer.Description__c='Discount';
        offer.Food_Item__c= fitem.Id;
        
        insert offer;
        return offer;
       // }
      //  catch(Exception e){
       //     System.debug('In createOffer: '+e.getMessage());
       //  return null;
       // }
    }
}