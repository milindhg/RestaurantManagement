/**
 * @author Milind Gokhale
 * This trigger: updateOrderBill is for updating the order bill amounts in the Order table.
 * Basic Logic: Always keep the BillAmount and Expected Bill Amount in the Order table with the latest total amounts.
 */

trigger updateOrderBill on Order_Item__c (after insert, after update, before delete) {
    //for (Order_Item__c itemInLoop : Trigger.new) {
        Integer i = 0;
        String intTest;
        
        //Check whether current operation is delete or not.
        if(Trigger.isDelete)
        {
            intTest = Trigger.old[i].id;
        }
        else
        {
            intTest = Trigger.new[i].id;
        }
        
        //Get the currently operated orderItem in the object
        Order_Item__c myOrderItem = [Select o.Type__c, o.Total_Price__c, o.Table_Number__c, 
                                        o.SystemModstamp, o.Status__c, o.Quantity__c, o.Price__c, 
                                        o.Name, o.LastViewedDate, o.LastReferencedDate, o.LastModifiedDate, 
                                        o.LastModifiedById, o.IsDeleted, o.Id, o.Food_Order__c, 
                                        o.Food_Item__c, o.CreatedDate, o.CreatedById 
                                        From Order_Item__c o
                                        where o.id=:intTest];
        System.debug('My OrderItem is: !!!!' + myOrderItem);
        
        
        Id myFoodOrderId = myOrderItem.Food_Order__c;
        System.debug('My Order is: !!!!' + myFoodOrderId);
        
        //get all the orderItems associated with the parent Order of the currently operated orderItem.
        List<Order_Item__c> allOrderItems = [Select o.Type__c, o.Total_Price__c, o.Table_Number__c, 
                                            o.SystemModstamp, o.Status__c, o.Quantity__c, o.Price__c, 
                                            o.Name, o.LastViewedDate, o.LastReferencedDate, o.LastModifiedDate, 
                                            o.LastModifiedById, o.IsDeleted, o.Id, o.Food_Order__c, 
                                            o.Food_Item__c, o.CreatedDate, o.CreatedById 
                                            From Order_Item__c o
                                            where o.Food_Order__c=:myFoodOrderId];
        System.debug('All Order Items in Current FoodOrder are: !!!!' + allOrderItems);
             
        //Calculate the updated bill amounts by adding the bill amounts of all the Child Order Items
        Decimal newTotalPrice = 0;
        for(Order_Item__c item : allOrderItems)
        {
            if(item.Total_Price__c!=null)
            {
                newTotalPrice += item.Total_Price__c;
            }
        }
        if(Trigger.isDelete)
            newTotalPrice -= myOrderItem.Total_Price__c;
        
        //Get the Food Order object and update it with the newly calculated bill amounts.
        Food_Order__c myFoodOrder = [Select f.TotalPrice__c, f.TableNumber__c, f.SystemModstamp, 
                        f.Status__c, f.OwnerId, f.OrderId__c, f.OrderDateTime__c, 
                        f.Name, f.LastViewedDate, f.LastReferencedDate, f.LastModifiedDate, 
                        f.LastModifiedById, f.IsDeleted, f.Id, f.DeliveryTime__c, 
                        f.CreatedDate, f.CreatedById 
                        From Food_Order__c f
                        where f.id=:myFoodOrderId];
        System.debug('My Order is: !!!!' + myFoodOrder);
        
        System.debug('My Order Current TotalPrice is: !!!!' + myFoodOrder.TotalPrice__c);
        myFoodOrder.TotalPrice__c = newTotalPrice;
        update(myFoodOrder);
        System.debug('My Order New TotalPrice is: !!!!' + myFoodOrder.TotalPrice__c);
        
    //}
}