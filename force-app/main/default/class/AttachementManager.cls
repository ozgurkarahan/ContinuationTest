@RestResource(urlMapping='/attachement/*')
global with sharing class AttachementManager {
    public AttachementManager() {

    }

    @HttpGet
    global static ResponseWrapper GetBlob(){
       
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String attachementId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

        if (attachementId == '') {
           return  null; 
        }

        Attachment attachement = [SELECT ParentId, body 
                                  FROM attachment 
                                  WHERE Id = :attachementId];
        if (attachement == null) {
           return  null; 
        }

        ResponseWrapper result = new ResponseWrapper();
        result.OptimumData = new OptimumData(attachement.Body.toString());
        //OptimumData result = 
        return result;
    }

    @httpPost
    global static Id SaveBlob(){
        RestRequest req = RestContext.request; 
        String postBodyXml = req.requestBody.toString();

		OptimumData optimumData = ParseXmlToOptimumList(postBodyXml);
        Id id = SaveAsAttachement(optimumData.InfosOptimum);

        return id;
    }

     global class ResponseWrapper {
       global OptimumData OptimumData {get; set;}
    }
    global class OptimumData {
        global OptimumData (String info){
            InfosOptimum = info;
        }
        global string InfosOptimum;
    }

    private static Id SaveAsAttachement(String infosOptimum){
        Attachment attachment = new Attachment();
        attachment.name = 'Attachement Blob';
        attachment.body = Blob.valueOf(infosOptimum);

        attachment.ParentId = GetTestOptimumAccountId();
        insert attachment;
        return attachment.Id;
    }

    private static Id GetTestOptimumAccountId(){
        
        string accountName = 'OptimumTest';
        List<Account> listAccounts = [SELECT Id 
                                  FROM Account 
                                  WHERE Name = :accountName];
        

        if (listAccounts != null && listAccounts.size() != 0) {
           return listAccounts[0].Id;
        }
        
        Account accountOptimum = new Account();
        accountOptimum.Name = accountName;
        insert accountOptimum; 
        return accountOptimum.Id;
    }

    private static OptimumData ParseXmlToOptimumList(string xml)
    {
        OptimumData result = new AttachementManager.OptimumData('empty data');
        try {
            Dom.Document doc = new Dom.Document();
            doc.load(xml);

            for (Dom.XmlNode node : doc.getRootElement().getChildElements()) {
                System.debug(node.getName());
                if (node.getName() == 'InfosOptimum') {
                   String infosOptimum = node.getText();
                   result.InfosOptimum = infosOptimum;
                   System.debug(infosOptimum);
                }
  		    }
            return result;

        } catch (Exception ex) {
             System.debug(ex.getMessage());
        }
        return result;
    }
}