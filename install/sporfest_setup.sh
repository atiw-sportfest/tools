#!/usr/bin/env bash

BASEDIR="/c/sportfest"
MYPASS="s3cret"

# Install

## Tomcat

[ -z "$TOMCAT"] && TOMCAT=$(ls -1 $(cygpath $USERPROFILE)/Downloads/apache-tomcat*.zip | sort --sort=version | head -n1)
[ -z "$TOMCAT"] && TOMCAT=$(ls -1 $(pwd)/apache-tomcat*.zip | sort --sort=version | head -n1)

while [ -z "$TOMCAT" ] || [ ! -f "$TOMCAT" ]; do 
	echo "(Auto-Completition enabled!)"
	read -ep "Path to Tomcat ZIP: " TOMCAT
done

echo $TOMCAT

## MariaDB

[ -z "$MARIADB" ] && MARIADB=$(ls -1 $(cygpath $USERPROFILE)/Downloads/mariadb*.zip | sort --sort=version | head -n1)
[ -z "$MARIADB" ] && MARIADB=$(ls -1 $(pwd)/mariadb*.zip | sort --sort=version | head -n1)

while [ -z "$MARIADB" ] || [ ! -f "$MARIADB" ]; do 
	echo "(Auto-Completition enabled!)"
	read -ep "Path to MariaDB ZIP: " MARIADB 
done

echo $MARIADB

# Setup

mkdir -p "${BASEDIR}"/{mariadb,tomcat}

## Tomcat

cd "${BASEDIR}"/tomcat
unzip $TOMCAT && mv apache-tomcat*/* . && rm -rf apache-tomcat*

## MariaDB

cd ../mariadb
unzip $MARIADB && mv mariadb*/* . && rm -rf mariadb*

## Database
bin/mysql_install_db --datadir "$(cygpath -aw "${BASEDIR}")\\mariadb\\db" --password "${MYPASS}"
 
cat >/c/sportfest/sportfest_run.bat <<EOT
cd /c $(cygpath -w "${BASEDIR}")
start cmd /c "cd mariadb\\db & ..\\bin\\mysqld --console"
start cmd /c "cd tomcat & bin\\startup.bat"
EOT

unix2dos "${BASEDIR}"/sportfest_run.bat

read -p "Ready. Press enter..."