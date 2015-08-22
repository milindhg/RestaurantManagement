@isTest(SeeAllData=true)
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
        
      Test.startTest();
       
	  Database.SaveResult result1 = Database.insert(resto, false);
      Database.SaveResult result2 = Database.insert(food_item, false);
      Database.SaveResult result3 = Database.insert(pbook, false);
      Database.SaveResult result4 = Database.insert(f_order, false);
      Database.SaveResult result5 = Database.insert(o_item, false);
     
     
	  DisplayCart dc = new DisplayCart(o_item); 
      DisplayMenuItems dm = new DisplayMenuItems(food_item, price);
      String img= dm.getimgurl();
      String offerimg = dm.getofferimgurl();
      Decimal timesordered= dm.getNumOfTimesOrdered();
      
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
      System.assertEquals(dm.price,6);
      System.assertEquals(dm.status, 'enabled');
      System.assertEquals(dm.isSpecial,True);
      System.assertEquals(dc.foodItem,null);
      System.assertEquals(dc.foodItemId,null);
      System.assertEquals(dc.foodOrder,null);
        
        
    }
    

    static testmethod void createOffer(){
        Restaurant__c resto = TestDataFactory.createRestaurant();
		Food_Item__c food_item = TestDataFactory.createFoodItem(resto);
        Offers__c offer = TestDataFactory.createOffer(food_item);
        DisplayOffer offerDis= new DisplayOffer(offer);
        String imgurl = offerDis.getimgurl();
        System.assertEquals(offerDis.getCount(),3);
        System.assertEquals(offerDis.discount,10);
        System.assertEquals(offerDis.description,'Discount');
        System.assertEquals(offerDis.name,null);
        
    }
    
    static testmethod void createTable(){
        Restaurant__c resto = TestDataFactory.createRestaurant();
        Table__c table = TestDataFactory.createTable(resto);
        tablecontroller tableCon = new tablecontroller();
        tablecontroller.Displaytables tableDis= new tablecontroller.Displaytables(table);
        System.assertEquals(tableDis.name,table.Name);
        System.assertEquals(tableDis.status,'Ready');
        System.assertEquals(tableDis.Seats,5);
        System.assertEquals(tableDis.TableNumber,'3');
        System.assertEquals(tableDis.urid,resto.Id);
        System.assertEquals(tableDis.waiter,'Waiter');
        List<tablecontroller.Displaytables> table_list = tableCon.gettables();
        String uid= tablecontroller.getRestoId();
        tableCon.updatestatus();
        
        
    }
    
    static testmethod void createWaiterOrder(){
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
      WaiterListController waiterCon= new WaiterListController();
      waiterCon.setSelectedRestaurant(resto.Id);
      String restoID= waiterCon.getSelectedRestaurant();
      WaiterListController.handleRefreshPage();
      Test.stopTest();
      
    }

    static testmethod void updateRawMaterialTest(){
        Restaurant__c resto = TestDataFactory.createRestaurant();
        insert resto;
        RawMaterial__c rawmaterial = TestDataFactory.createRawMaterial(resto);
        RawMaterial__c mat = [Select m.Used__c from RawMaterial__c m where m.Id=:rawmaterial.Id];
        mat.Used__c=2;
        update rawmaterial;
    }
    
    static testMethod void myUnitTest() {

            Test.startTest();
                    String CRON_EXP = '0 0 0 1 1 ? 2025';  
                    String jobId = System.schedule('testScheduledApex', CRON_EXP, new DeleteOrderItems() );

                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];

                    System.assertEquals(CRON_EXP, ct.CronExpression); 
                    System.assertEquals(0, ct.TimesTriggered);
                    System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));

            Test.stopTest();
    }
    
    static testmethod void createBill(){
        
        Bill bill_new = new Bill('a0537000000T9g7');
        List<DisplayCart> orderItems = bill_new.getOrderItemsList();
        bill_new.SetSelectedFQ('5');
        bill_new.SetSelectedOAE('4');
        bill_new.SetSelectedService('4');
        bill_new.setlikes('3');
        bill_new.insertfeedback();
        bill_new.getFoodOrder();
       	String likes= bill_new.getlikes();
        String fq= bill_new.getSelectedFQ();
        String oae = bill_new.getSelectedOAE();
        String unlikes = bill_new.getUnlikes();
        bill_new.finish();
        bill_new.backToCart();
        
    }

}