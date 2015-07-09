/**
 * @author Milind Gokhale
 * Creation Date: July 7, 2015
 * This trigger: updateOrderBill is for updating the order bill amounts in the Order table.
 * Basic Logic: Always keep the BillAmount and Expected Bill Amount in the Order table with the latest total amounts.
 *              Whether the order items are inserted, updated or deleted.
 * 
 * Change 1. Added logic for maintaining expected bill amount along with the total bill (Total price) of the order.
 * Change 2. Added logic for maintaining the order status as new if any of the order items are new.
 */

trigger updateOrderBill on Order_Item__c (after insert, after update, before delete) {
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
        
        String[] types = new String[] {'Order_Item__c'};
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('The results are: !!!!' + results);
        
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
        Decimal newExpectedBill = 0;
        Boolean orderStatusNewFlag = false;
        
        for(Order_Item__c item : allOrderItems)
        {
            if(item.Total_Price__c!=null)
            {
                newExpectedBill += item.Total_Price__c;
                if(item.Status__c == 'Accepted' || item.Status__c == 'Ready' || item.Status__c == 'Picked Up' || item.Status__c == 'Pending')
                {
                    newTotalPrice += item.Total_Price__c;
                }
                if(item.Status__c == 'New' && orderStatusNewFlag==false)
                {
                    orderStatusNewFlag=true;
                }
            }
        }
        //If the current operation on orderItem is delete, 
        //then we don't want to include the total price of that orderitem in our new bill amounts.
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
        myFoodOrder.TotalPriceEstimate__c = newExpectedBill;
        if(orderStatusNewFlag)
        {
            myFoodOrder.Status__c='New';
        }
        update(myFoodOrder);
        System.debug('My Order New TotalPrice is: !!!!' + myFoodOrder.TotalPrice__c);
        
}