trigger usedupdation on RawMaterial__c (before update) {

for (RawMaterial__c rm :Trigger.new){

rm.Used_till_now__c = rm.Used_till_now__c + rm.Used__c;

}
}