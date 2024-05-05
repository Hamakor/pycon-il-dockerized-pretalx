#!/bin/bash

# Initialize database -- define user and db and add contents

DB="-h db -u root -p$MARIADB_ROOT_PASSWORD"

envsubst < init-mysql.sql | mysql $DB
bunzip2 /var/init/data/db.dump.bz2 --stdout | mysql $DB $PRETALX_DB_NAME

# Initialize filesystem data
cd /var/pretalx/data
tar xzf /var/init/data/var-pretalx-data.tgz --strip-components=3
