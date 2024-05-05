#!/bin/bash

# we have now moved to official pretalx package, no need to backup source

file_name="backup_$(date +"%Y%m%d-%H%M%S")_full.tar.bz2"

rm -f /tmp/db.dump /tmp/data.dump

mysqldump -h db -u root -p${MARIADB_ROOT_PASSWORD} \
	  --default-character-set=utf8mb4 ${PRETALX_DB_NAME} > /tmp/db.dump

# due to use of django-scopes the following command will no longer work, so we
# have created our own script to disable scopes
#/var/pretalx/venv/bin/python /var/pretalx/pretalx/src/manage.py dumpdata > /tmp/data.dump
/root/tasks/pretalx_dumpdata.py > /tmp/data.dump


# we are using official pretalx package, no need to backup git diff
#(cd /var/pretalx/pretalx ; git diff > /tmp/pretalx.diff)
#	-C /tmp /tmp/db.dump /tmp/data.dump /tmp/pretalx.diff \
#        /var/pretalx/pretalx/src/pretalx/settings.py \

tar -cvjf /root/backups/${file_name} \
	-C /tmp /tmp/db.dump /tmp/data.dump \
        -C / \
	/etc/pretalx \
	/var/pretalx/data \
	/root/tasks

#rm /tmp/db.dump /tmp/pretalx.diff
rm /tmp/db.dump /tmp/data.dump
