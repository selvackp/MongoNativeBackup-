export PATH=/bin:/usr/bin:/usr/local/bin
#Decalre Today Date
TODAY=`date +"%d%b%Y"`

#Declare Variables Required to pass for mongo dump command
DB_BACKUP_PATH='/mnt/mongobackup'
MONGO_HOST='localhost'
MONGO_PORT='27017'
MONGO_USER='xxxxxxxxxxx'
MONGO_PASSWD='xxxxxxxxxxxxx'
DATABASE_NAMES='ALL'

#Remove Old Backup Files 
find ${DB_BACKUP_PATH} -name "*.zip" -type f -mtime +3 -delete

find ${DB_BACKUP_PATH} -type d -mtime +3 -exec rm -rf {} \;

#Create Directory for Backup
mkdir -p ${DB_BACKUP_PATH}/${TODAY}
cd ${DB_BACKUP_PATH}/${TODAY}/

if [ ${DATABASE_NAMES} = "ALL" ]; then
	echo "You have choose to backup all database"
	mongodump --uri="mongodb://${MONGO_USER}:${MONGO_PASSWD}@${MONGO_HOST}:${MONGO_PORT}"
else
	echo "Running backup for selected databases"
	for DB_NAME in ${DATABASE_NAMES}
	do
	mongodump --uri="mongodb://${MONGO_USER}:${MONGO_PASSWD}@${MONGO_HOST}:${MONGO_PORT}/${DB_NAME}"
	done
fi

#Compress The Backup
cd ${DB_BACKUP_PATH}/${TODAY}

zip -r ${DB_BACKUP_PATH}_${TODAY}.zip ${DB_BACKUP_PATH}/${TODAY}

cd ${DB_BACKUP_PATH}/${TODAY}

#Copy the Compressed file into Azure Container using Shared Access Token
azcopy cp ${DB_BACKUP_PATH}_${TODAY}.zip "https://xxxxxxxxxxx.blob.core.windows.net/xxxxxxxxxxxx?sp=w&st=xxxxxTxxxxxxxZ&se=xxxxxxZ&spr=https&sv=2021-06-08&sr=c&sig=csdfcdsxxxxxxxxxxxxxxx" --recursive=true

#Send Mail with Backup Logs 
if [ $? -ne 0 ]
then
        echo "Mongo Native backup Failed in $(hostname) $(date). Please contact administrator." | mail -r mail@datablogs.com -s "Mongo Native backup Failed $(hostname)" dbsupport@datablogs.com < /mongodata/cronscripts/mongo_backup_log.log

        else

        echo "Mongo Native backup completed in $(hostname)." | mail -r mail@datablogs.com -s "Mongo Native backup completed in $(hostname)" dbsupport@datablogs.com < /mongodata/cronscripts/mongo_backup_log.log
fi
