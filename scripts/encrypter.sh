#!/bin/bash

##
# GPG - non interactive mode
#
# gpg --yes --batch --passphrase=[Enter your passphrase here] -c filename.txt
# gpg --yes --batch --passphrase=[Enter your passphrase here] filename.txt.gpg

BACKUP_DIR=/tmp/example-backup-dir
OUTPUT_FILE=/tmp/example-backup-dir.tar.gz
PASSPHRASE=my_secret_password

if [ -d $BACKUP_DIR ]; then
    rm -r $BACKUP_DIR
fi

mkdir $BACKUP_DIR

for i in {1..5}
do
    echo "Testing $i" > $BACKUP_DIR/file-$i.txt
done

tar -pczf $OUTPUT_FILE $BACKUP_DIR

gpg --yes --batch --passphrase=$PASSPHRASE -c $OUTPUT_FILE

rm $OUTPUT_FILE

