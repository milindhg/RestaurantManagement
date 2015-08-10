@isTest(seeAllData=true)
public class Resto_Utility_Chef {
 

 static testmethod void CreateChef(){
      ChefListController chef= new ChefListController();
      Restaurant__c resto = TestDataFactory.createRestaurant();
      Table__c t = TestDataFactory.createTable(resto);
      Food_Item__c food_item = TestDataFactory.createFoodItem(resto);
      PriceBook__c pbook = TestDataFactory.createPriceBook(resto, food_item);
      Food_Order__c f_order = TestDataFactory.createFoodOrder(resto, Decimal.valueOf(t.Table_Number__c), food_item, pbook);
      Order_Item__c o_item = TestDataFactory.createOrderitem(resto, f_order, food_item, pbook);
      List<PriceBook__c> price = new List<PriceBook__c>();
      price.add(pbook);
      
      Test.startTest();
       
	  Database.SaveResult result1 = Database.insert(resto, false);
      Database.SaveResult result2 = Database.insert(food_item, false);
      Database.SaveResult result3 = Database.insert(pbook, false);
      Database.SaveResult result4 = Database.insert(f_order, false);
      Database.SaveResult result5 = Database.insert(o_item, false);
     
      String ready_id = ChefListController.itemReadyUpdate('a0137000000N1YcAAK');
      System.assertEquals('a0137000000N1YcAAK', ready_id);
 
      String accept_id = ChefListController.itemAcceptUpdate('a0137000000N1YcAAK','a0537000000RI9bAAG');
      System.assertEquals('success', accept_id);
     
      String s = ChefListController.getRestoId();
      System.assertEquals('R-0000', s);
     
      String br = ChefListController.getRestoBranch();
      System.assertEquals('Sawmill, Columbus, Ohio, 43235', br);
     
      ChefListController.updateNoChefs('2');
      ChefListController.handleRefreshPage();
      chef.getnoofchefs();
     
     chef.getselectedlocation();
      chef.getselectedNoChefs();
      chef.setselectedlocation('R-0000');
      chef.setselectedNoChefs('5');
     
	  Test.stopTest();
    }
}