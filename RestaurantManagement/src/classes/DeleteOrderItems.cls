global class DeleteOrderItems implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
       List<Order_Item__c> o = [SELECT Id
                                FROM Order_Item__c
                                WHERE Delete_Status__c = 'Yes'];
       Database.delete(o);                         
      }
}