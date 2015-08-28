@isTest
public class MenuItemListControllerTest{
	
	static Id tableId;
	static String restaurantId;
	static Id categoryLevel1Id;
	static Id categoryLevel2Id;
	static Restaurant__c restaurantObject;
	static Table__c tableObject;
	
	static  void setupdata(){
		restaurantObject = new Restaurant__c();
		restaurantObject.Branch__c='ABC';
		restaurantObject.City__c='NY';
		restaurantObject.Country__c='USA';
		restaurantObject.Name = 'Restaurant1';
		restaurantObject.State__c='Ohio';
		
		restaurantObject.Manager__c='ABC';
		restaurantObject.Street_Address__c='Manhanttan';
		restaurantObject.Zip__c='12345';
		
		insert restaurantObject;
		restaurantId = restaurantObject.id;
		system.debug('Restaurant Id = '+restaurantObject.id);
		system.debug('restaurantObject.Restaurant_ID__c >>'+restaurantObject.Restaurant_ID__c);
		
		tableObject = new Table__c();
		tableObject.No_of_seats__c = 10;
		tableObject.Restaurant_Branch__c = restaurantObject.id;
		tableObject.Status__c ='Ready';
		tableObject.Table_Number__c = '2';
		tableObject.Waiter__c='waiter';
		insert tableObject;
		tableId = tableObject.id ;
		system.debug('tableObject Id >>>>>>>>>> '+tableId);
		
		ApexPages.currentPage().getParameters().put('reqlocation',restaurantObject.Restaurant_ID__c);
		ApexPages.currentPage().getParameters().put('tableid',tableObject.Table_Number__c);
		
		Category_Level_1__c categoryLevel1Object = new Category_Level_1__c();
		categoryLevel1Object.Name ='Sea Food';
		insert categoryLevel1Object;
		categoryLevel1Id = categoryLevel1Object.id ;
		
		Category_Level_2__c categoryLevel2Object = new Category_Level_2__c();
		categoryLevel2Object.CategoryFirstLevel__c = categoryLevel1Id;
	
		categoryLevel2Object.Name='Fish';
		
		insert categoryLevel2Object;
		categoryLevel2Id = categoryLevel2Object.Id;
	}
	
	static testMethod void testMenuItemListControllerTestConstructor(){
		setupdata();
		Test.startTest();
		MenuItemListController MenuItemListControllerObject = new MenuItemListController();
		//Zero Argument Constructor	
		MenuItemListController MenuItemListControllerObject1 = new MenuItemListController(restaurantObject.Restaurant_ID__c, tableObject.Table_Number__c);
		// Parameterized Constuctor
		
		Test.stopTest();
	}
	
	/*
	static void setupDataForFoodOrder(){
		setupdata();
		
		 List<Food_Order__c> existingOrder = [Select f.TotalPrice__c, f.TableNumber__c, f.SystemModstamp, 
            f.Status__c,  f.OrderId__c, f.OrderDateTime__c, f.Name, f.Location__c, f.Restaurant_Branch__r.Restaurant_ID__c, 
            f.LastReferencedDate, f.LastModifiedDate, f.LastModifiedById, 
            f.IsDeleted, f.Id, f.DeliveryTime__c, f.CreatedDate, f.CreatedById From Food_Order__c f
                                     where f.TableNumber__c=:tableNo and f.Status__c != 'Paid' and f.Restaurant_Branch__r.Restaurant_ID__c=:selLocation];
		
		
		Food_Order__c foodOrderObject = new Food_Order__c();
		foodOrderObject.TotalPrice__c = 10.20;
		foodOrderObject.TableNumber__c = '2';
		foodOrderObject.SystemModstamp ='8/21/2015';
		foodOrderObject.Status__c='New';
		foodOrderObject.OrderDateTime__c ='8/13/2015 10:21 AM';
		foodOrderObject.Name ='foodORder';
		foodOrderObject.Location__c='Pune';
		foodOrderObject.Restaurant_Branch__c = restaurantId;
		foodOrderObject.LastReferencedDate = '8/13/2015 10:21 AM';
		foodOrderObject.LastModifiedDate = '8/27/2015';
		
		
		
		
	}
	*/
	
	
	/*
	static testMethod void testGetFoodOrder(){
		
	}*/
	
	
}