-- First create a staging table for you XML file
create table dbo.XML_IMPORT (xml_data xml);

-- Now create a database scoped credential 
CREATE DATABASE SCOPED CREDENTIAL MyAzureBlobStorageCredential
 WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
 SECRET = '<SAS_TOKEN>'; -- Remove prefix '?'
 
-- Use the credential to create an external data source for you blobstorage
CREATE EXTERNAL DATA SOURCE AzureBlobStorage1 
    WITH (   
        TYPE = BLOB_STORAGE,  
        LOCATION = 'https://<STORAGE_ACCOUNT_NAME>.blob.core.windows.net/samtest',
        CREDENTIAL = MyAzureBlobStorageCredential
    );

-- Finally insert your data into the table
INSERT INTO [dbo].[XML_IMPORT] (XML_DATA)
SELECT CAST(BulkColumn AS XML)
FROM OPENROWSET
(
 BULK '<FILE_PATH_INCLUDING_FILENAME_AND_EXTENSION>',
 DATA_SOURCE = 'AzureBlobStorage1', 
 SINGLE_BLOB
) AS XML_IMPORT

