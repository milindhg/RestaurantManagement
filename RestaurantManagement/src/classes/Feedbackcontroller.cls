public with sharing class Feedbackcontroller {
    
    public String SelectedFQ;
    public String SelectedService;
    public String SelectedOAE;
    public String likes;
    public String unlikes;
    
     
    public String getSelectedFQ() {
        return SelectedFQ;
    }
     
    public void setSelectedFQ(String recType) {
        this.SelectedFQ= recType;
    }
    
    
    public String getSelectedService() {
        return SelectedService;
    }
     
    public void setSelectedService (String recType) {
        this.SelectedService= recType;
    }
    
    public String getSelectedOAE () {
        return SelectedOAE;
    }
     
    public void setSelectedOAE (String recType) {
        this.SelectedOAE = recType;
    }
    
    
    public String getlikes() {
        return likes;
    }
     
    public void setlikes(String recType) {
        this.likes= recType;
    }
    
    public String getunlikes() {
        return unlikes;
    }
     
    public void setunlikes(String recType) {
        this.unlikes= recType;
    }
   
    public Feedbackcontroller() {
    }
    
    public void insertfeedback()
    {
    Feedback__c fb = new Feedback__c();
    fb.Food_Quality__c=SelectedFQ;
    fb.Overall_Experience__c=SelectedOAE;
    fb.Service__c=SelectedService;
    fb.What_I_liked__c=likes;
    fb.What_must_have_been_there__c=unlikes;
    insert fb;
    likes=null;
    unlikes=null;
    }
    
      
}