/**
 * @author Milind Gokhale
 * Creation Date: July 7, 2015
 * This trigger: updateOrderBill is for updating the order bill amounts in the Order table.
 * Basic Logic: Always keep the BillAmount and Expected Bill Amount in the Order table with the latest total amounts.
 *              Whether the order items are inserted, updated or deleted.
 * 
 * Change 1. Added logic for maintaining expected bill amount along with the total bill (Total price) of the order.
 * Change 2. Added logic for maintaining the order status as new if any of the order items are new.
 * Change 3. Added fix for updating the total price exptected on deleting an item from the order items.
 * Change 4. Added fix for correctly updating the totals - taxes, prices and estimated prices and taxes of the foodOrder object when the child orderitem is marked deleted.
 */

trigger updateOrderBill on Order_Item__c (after insert, after update, before delete) {
        public static final String PAID = 'Paid';
        public static final String NAVA = 'New';
        public static final String PENDING = 'Pending';
        public static final String ACCEPTED = 'Accepted';
        public static final String READY = 'Ready';
        public static final String PICKEDUP = 'Picked Up';
        public static final String DELIVERED = 'Delivered';

        Integer i = 0;
        String intTest;
        Decimal taxRate = 0.075;
        
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
                                        o.Name, o.LastModifiedDate, 
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
                                            o.Name, o.LastModifiedDate, 
                                            o.LastModifiedById, o.IsDeleted, o.Id, o.Food_Order__c, 
                                            o.Food_Item__c, o.CreatedDate, o.CreatedById 
                                            From Order_Item__c o
                                            where o.Food_Order__c=:myFoodOrderId and o.Delete_Status__c <> 'Yes'];
        System.debug('All Order Items in Current FoodOrder are: !!!!' + allOrderItems);
             
        //Calculate the updated bill amounts by adding the bill amounts of all the Child Order Items
        Decimal newPrice = 0;
        Decimal newPriceEstimate = 0;
        Decimal newTax = 0;
        Decimal newTaxEstimate = 0;
        Decimal newTotalPrice = 0;
        Decimal newTotalPriceEstimate = 0;
        Boolean orderStatusNewFlag = false;
        Boolean orderStatusDeliveredFlag = true;
        
        for(Order_Item__c item : allOrderItems)
        {
            if(item.Total_Price__c!=null)
            {
                newPriceEstimate += item.Total_Price__c;
                if(item.Status__c == ACCEPTED || item.Status__c == READY || item.Status__c == PICKEDUP || item.Status__c == PENDING || item.Status__c == DELIVERED)
                {
                    newPrice += item.Total_Price__c;
                }
                //Logic for keeping the order status as delivered if and only if all the items in the order are delivered.
                if(item.Status__c != DELIVERED && orderStatusDeliveredFlag==true)
                {
                    orderStatusDeliveredFlag=false;
                }
                //Logic for keeping the order status as delivered if and only if all the items in the order are delivered.
                if(item.Status__c == NAVA && orderStatusNewFlag==false)
                {
                    orderStatusNewFlag=true;
                }
                
            }
        }
        //If the current operation on orderItem is delete, 
        //then we don't want to include the total price of that orderitem in our new bill amounts.
        if(Trigger.isDelete){
            newPrice -= myOrderItem.Total_Price__c;
            newPriceEstimate -= myOrderItem.Total_Price__c;
        }
        
        //Calculate tax on the prices
        newTax = newPrice * taxRate;
        newTaxEstimate = newPriceEstimate * taxRate;
        
        //Get the Food Order object and update it with the newly calculated bill amounts.
        Food_Order__c myFoodOrder = [Select f.TotalPrice__c, f.TableNumber__c, f.SystemModstamp, 
                        f.Status__c, f.OrderId__c, f.OrderDateTime__c, 
                        f.Name, f.LastModifiedDate, 
                        f.LastModifiedById, f.IsDeleted, f.Id, f.DeliveryTime__c, 
                        f.CreatedDate, f.CreatedById 
                        From Food_Order__c f
                        where f.id=:myFoodOrderId];
        System.debug('My Order is: !!!!' + myFoodOrder);
        
        System.debug('My Order Current TotalPrice is: !!!!' + myFoodOrder.TotalPrice__c);
        myFoodOrder.Price__c = newPrice;
        myFoodOrder.PriceEstimate__c = newPriceEstimate;
        myFoodOrder.Tax__c = newTax;
        myFoodOrder.TaxEstimate__c = newTaxEstimate;
        myFoodOrder.TotalPrice__c = newPrice + newTax;
        myFoodOrder.TotalPriceEstimate__c = newPriceEstimate + newTaxEstimate;
        
        if(orderStatusDeliveredFlag)
        {
            myFoodOrder.Status__c=DELIVERED;
        }
        else if(orderStatusNewFlag)
        {
            myFoodOrder.Status__c=NAVA;
        }
        update(myFoodOrder);
//trial comments written from tablet. .
//comment end
//
}