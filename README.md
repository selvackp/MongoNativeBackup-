# MongoNativeBackup-

Mongo Native Backup and Upload the dump into Azure Blob

Prerequisite :

1.Create Azure Container also generate Shared access token with Write and Create Permissions 

2.azcopy installed in the Linux or Window Machine

wget https://aka.ms/downloadazcopy-v10-linux

tar -xvf downloadazcopy-v10-linux

sudo rm /usr/bin/azcopy

sudo cp ./azcopy_linux_amd64_*/azcopy /usr/bin/

Once all set , we can schdule the backup using cron and make use of this 
