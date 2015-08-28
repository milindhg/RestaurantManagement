@isTest
public class tablecontrollerTest {
	
	static Id tableId;
	static String restaurantId;
	static  void setupdata(){
		Restaurant__c restaurantObject = new Restaurant__c();
		restaurantObject.Branch__c='ABC';
		restaurantObject.City__c='NY';
		restaurantObject.Country__c='USA';
		restaurantObject.Name = 'Restaurant1';
		restaurantObject.State__c='Ohio';
		
		restaurantObject.Manager__c='ABC';
		restaurantObject.Street_Address__c='Manhanttan';
		restaurantObject.Zip__c='12345';
		
		insert restaurantObject;
		system.debug('Restaurant Id = '+restaurantObject.id);
		system.debug('restaurantObject.Restaurant_ID__c >>'+restaurantObject.Restaurant_ID__c);
		
		Table__c tableObject = new Table__c();
		tableObject.No_of_seats__c = 10;
		tableObject.Restaurant_Branch__c = restaurantObject.id;
		tableObject.Status__c ='Ready';
		tableObject.Table_Number__c = '2';
		tableObject.Waiter__c='waiter';
		insert tableObject;
		tableId = tableObject.id ;
		system.debug('tableObject Id >>>>>>>>>> '+tableId);
	}
	
	static testMethod void testGetRestoId(){
		setupdata();
		Test.startTest(); 
		restaurantId = tablecontroller.getRestoId();
		system.debug('Restaurant Id >>>>>>>>>>>> '+restaurantId);
		Test.stopTest();
		System.assertNotEquals(restaurantId, null);
	}
	
	static testMethod void testUpdatestatus(){
		setupdata();
		Test.startTest(); 
		ApexPages.currentPage().getParameters().put('tablename',tableId);
		tablecontroller tablecontrollerobject = new tablecontroller();
		tablecontrollerobject.updatestatus();
		Test.stopTest();
	}
	
	static testMethod void testGettables(){
		setupdata();
		Test.startTest(); 
		tablecontroller tablecontrollerobject = new tablecontroller();
		tablecontroller.uid = restaurantId;
		tablecontrollerobject.gettables();
		Test.stopTest();
	}
}