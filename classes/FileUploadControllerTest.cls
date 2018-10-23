@isTest
private class FileUploadControllerTest {
    static testMethod void uploadTest(){
        Blob file_firsthalf = Blob.valueOf('This contains d');
        Blob file_secondhalf = Blob.valueOf('ummy text.');
        
        String filefirsthalfbase64 = EncodingUtil.base64Encode(file_firsthalf);
        String secondfirsthalfbase64 = EncodingUtil.base64Encode(file_secondhalf);
        
        Account account = new Account(name='test account');
        insert account;
        
        Test.startTest();
        String attachmentId = FileUploadController.attachBlob('','fileName',filefirsthalfbase64);
        FileUploadController.attachBlob(attachmentId,'fileName',secondfirsthalfbase64);
        FileUploadController.linkParent(account.Id,attachmentId);
        Test.stopTest();
        
        List<ContentDocument> documents = [SELECT Id FROM ContentDocument];
        System.assert(documents.size() == 1);
    }
}