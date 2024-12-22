#!/bin/sh
/bin/sed -i "s/ADMIN_PASSWORD/$ADMIN_PASSWORD/g" /run/shiro.ini
/opt/fuseki-server