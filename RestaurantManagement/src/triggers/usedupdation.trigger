trigger usedupdation on RawMaterial__c (Before update) {

for (RawMaterial__c rm :Trigger.new){

rm.Used_till_now__c = rm.Used_till_now__c + rm.Used__c;

}
}