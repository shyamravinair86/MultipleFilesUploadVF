global with sharing class FileUploadController {
    
    @RemoteAction
    global static String attachBlob(String parentId, String attachmentId, String fileName, String contentType, String base64BlobValue){
        String contentId = '';
        if(attachmentId == '' || attachmentId == null){
            ContentVersion cv = new ContentVersion();
            cv.VersionData = EncodingUtil.Base64Decode(base64BlobValue);
            cv.Title = fileName;
            cv.PathOnClient = '/foo.txt';
            cv.IsMajorVersion = false;
            insert cv;
            contentId = cv.Id;
        }
        else{
            for(ContentVersion cv :[SELECT Id,VersionData FROM ContentVersion WHERE Id =:attachmentId]){
                update new ContentVersion(Id = attachmentId, VersionData = EncodingUtil.Base64Decode(EncodingUtil.Base64Encode(cv.VersionData) + base64BlobValue));
            }
            contentId = attachmentId;
        }
        return contentId;
    }
    
    @RemoteAction
    global static void linkParent(String parentId, String attachmentId){
        ContentDocument cd = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId=:attachmentId];
        ContentDocumentLink cdl = new ContentDocumentLink();
        if(cd != null){
            cdl.ContentDocumentId = cd.Id;
            cdl.LinkedEntityId = parentId;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl;
        }
        //return cdl.Id;
    }

}