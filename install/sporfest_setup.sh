#!/usr/bin/env bash

BASEDIR="/c/sportfest"
MYPASS="s3cret"

# Install

## TomEE

[ -z "$TOMEE"] && TOMEE=$(ls -1 $(cygpath $USERPROFILE)/Downloads/apache-tomee*.zip | sort --sort=version | head -n1)
[ -z "$TOMEE"] && TOMEE=$(ls -1 $(pwd)/apache-tomee*.zip | sort --sort=version | head -n1)
[ -z "$TOMEE"] && curl -L "http://repo.maven.apache.org/maven2/org/apache/tomee/apache-tomee/7.0.4/apache-tomee-7.0.4-webprofile.zip" && \
    TOMEE=$(ls -1 $(pwd)/apache-tomee*.zip | sort --sort=version | head -n1)

while [ -z "$TOMEE" ] || [ ! -f "$TOMEE" ]; do
	echo "(Auto-Completition enabled!)"
	read -ep "Path to TomEE ZIP: " TOMEE
done

echo $TOMEE

## MariaDB

[ -z "$MARIADB" ] && MARIADB=$(ls -1 $(cygpath $USERPROFILE)/Downloads/mariadb*.zip | sort --sort=version | head -n1)
[ -z "$MARIADB" ] && MARIADB=$(ls -1 $(pwd)/mariadb*.zip | sort --sort=version | head -n1)
[ -z "$MARIADB" ] && curl -L "https://downloads.mariadb.org/interstitial/mariadb-10.2.11/win32-packages/mariadb-10.2.11-win32.zip" && \
    MARIADB=$(ls -1 $(pwd)/mariadb*.zip | sort --sort=version | head -n1)

while [ -z "$MARIADB" ] || [ ! -f "$MARIADB" ]; do
	echo "(Auto-Completition enabled!)"
	read -ep "Path to MariaDB ZIP: " MARIADB 
done

echo $MARIADB

# Setup

mkdir -p "${BASEDIR}"/{mariadb,tomee}

## Tomcat

cd "${BASEDIR}"/tomee
unzip $TOMEE && mv apache-tomee*/* . && rm -rf apache-tomee*

## MariaDB

cd ../mariadb
unzip $MARIADB && mv mariadb*/* . && rm -rf mariadb*

## Database
bin/mysql_install_db.exe --datadir db --password "${MYPASS}" # --password is windows only

bin/mysqld --console &
bin/mysqladmin create sportfest
kill $!

## Connector

curl {https://downloads.mariadb.com/Connectors/java/connector-java-2.2.0/,../tomee/lib/}mariadb-java-client-2.2.0.jar
 
cat >/c/sportfest/sportfest_run.bat <<EOT
cd /c $(cygpath -w "${BASEDIR}")
start cmd /c "cd mariadb\\db & ..\\bin\\mysqld --console"
start cmd /c "cd tomee & bin\\startup.bat"
EOT

unix2dos "${BASEDIR}"/sportfest_run.bat

echo "Database host:     localhost"
echo "Database name:     sportfest"
echo "Database user:     root"
echo "Database password: $MYPASS"
echo

read -p "Ready. Press enter..."
