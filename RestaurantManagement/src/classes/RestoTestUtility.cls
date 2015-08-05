@isTest
private class RestoTestUtility {

    static testmethod void insertRestaurant() {
     
	  Restaurant__c resto = TestDataFactory.createRestaurant();
      Table__c t = TestDataFactory.createTable(resto);
      Food_Item__c food_item = TestDataFactory.createFoodItem(resto);
      PriceBook__c pbook = TestDataFactory.createPriceBook(resto, food_item);
      Food_Order__c f_order = TestDataFactory.createFoodOrder(resto, Decimal.valueOf(t.Table_Number__c), food_item, pbook);
      Order_Item__c o_item = TestDataFactory.createOrderitem(resto, f_order, food_item, pbook);  
      List<PriceBook__c> price = new List<PriceBook__c>();
      price.add(pbook);
      
      //Chef__c chef = TestDataFactory.createChef(resto);
      //RawMaterial__c raw_mat = TestDataFactory.createRawMaterial(resto);  
        
      Test.startTest();
       
	  Database.SaveResult result1 = Database.insert(resto, false);
      Database.SaveResult result2 = Database.insert(food_item, false);
      Database.SaveResult result3 = Database.insert(pbook, false);
      Database.SaveResult result4 = Database.insert(f_order, false);
     
     
	  DisplayCart dc = new DisplayCart(o_item); 
      DisplayMenuItems dm = new DisplayMenuItems(food_item, price);  
	  Test.stopTest();
       
      System.assert(result1.isSuccess());
      System.assertEquals(dc.status,'New');
      System.assertEquals(dc.Name,'Test Order Item');
      System.assertEquals(dc.Quantity,2);
      System.assertEquals(dc.status,'New');
      System.assertEquals(dm.name,'Test');
      System.assertEquals(dm.Category,'Appetizer');  
      System.assertEquals(dm.description,'Test Food Item');
      System.assertEquals(dm.typ,'Vegan');
      System.assertEquals(dm.Calories,100);
      System.assertEquals(dm.preptime,20);
      System.assertEquals(dm.spiceLevel,'Medium');
      System.assertEquals(dm.priceBook,pbook.Id);
        
    }
    
    /*static testmethod void deleteRestaurant() {

	Restaurant__c resto = TestDataFactory.createRestaurant();
	Test.startTest();
	Database.DeleteResult result = Database.delete(resto, false);
	Test.stopTest();

	System.assert(result.isSuccess());
    }*/
}