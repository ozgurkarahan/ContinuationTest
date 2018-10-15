@RestResource(urlMapping='/ContentVersion/*')
global with sharing class ContentVersion {
    public ContentVersion() {

    }

    @httpPost
    global static string SaveBlob(){

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
     
        String postBodyXml = req.requestBody.toString();
		List<OptimumData> optimumData = ParseXmlToOptimumList(postBodyXml);

        System.debug(postBodyXml);
        return postBodyXml;
    }

    global class OptimumData {
        global OptimumData (String info){
            InfosOptimum = info;
        }
        global string InfosOptimum;
    }

    private static List<OptimumData> ParseXmlToOptimumList(string xml)
    {
        List<OptimumData> result = new List<OptimumData>();
        Dom.Document doc = new Dom.Document();
  		doc.load(xml);
        
        for (Dom.XmlNode node : doc.getRootElement().getChildElements()) {
    		String infosOptimum = node.getAttributeValue('InfosOptimum', '');
            OptimumData op = new OptimumData(infosOptimum);
    		result.add(op);
  		}
        return result;
    }
}