public class AgentforceDocumentHandler {
    @InvocableMethod(label='Upload Document to Attachment' description='Uploads a document and saves it as an Attachment')
    public static List<UploadResult> uploadDocument(List<InputData> inputDataList) {
        List<UploadResult> results = new List<UploadResult>(); // Store the result of each upload

        for (InputData inputData : inputDataList) {
            UploadResult result = new UploadResult();
            result.recordId = inputData.recordId; 

            try {
                // 1. Get the necessary data from the input
                String recordId = inputData.recordId;
                String fileName = inputData.fileName;  // Get fileName from inputData
                Blob fileData = EncodingUtil.base64Decode(inputData.fileData);

                // 2. Create the Attachment record
                Attachment attachment = new Attachment();
                attachment.ParentId = recordId;
                attachment.Name = fileName;
                attachment.Body = fileData;

                // 3. Insert the Attachment
                insert attachment;
                result.success = true;
                result.message = 'Document "' + fileName + '" uploaded successfully.';

            } catch (Exception e) {
                // 4. Handle errors
                result.success = false;
                result.message = 'Error uploading document "' + inputData.fileName + '": ' + e.getMessage();  // Use inputData.fileName
                System.debug(result.message);
            } finally {
                results.add(result);
            }
        }
        return results;
    }

    public class InputData {
        @InvocableVariable(required=true)
        public String recordId;
        @InvocableVariable(required=true)
        public String fileName;
        @InvocableVariable(required=true)
        public String fileData; //  Base64 encoded file
    }

    public class UploadResult {
        @InvocableVariable
        public String recordId;
        @InvocableVariable
        public Boolean success;
        @InvocableVariable
        public String message;
    }
}