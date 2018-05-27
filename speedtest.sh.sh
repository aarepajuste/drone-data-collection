#!/bin/bash
TIME=$(date | awk '{print $4}')
DATE=$(date +%d-%m-%Y)

if [ -e /home/droon/logid/speedtest-$DATE.csv ]
then
        echo "Logifailid eksisteerivad, kirjutan informatsiooni..."
else
        echo "Logifailid ei eksisteeri. Tekitan csv faili esimese reaga ning kirjutan ülejäänud informatsiooni..."
        touch /home/droon/logid/speedtest-$DATE.csv
        echo "DATE, TIME, PING, DOWNLOAD, UPLOAD" >> /home/droon/logid/speedtest-$DATE.csv
fi

DATA=$(/usr/bin/speedtest-cli --simple --server 3207)

#Puhastab informatsiooni
PING=$(echo "$DATA" | grep "Ping:" | awk '{print $2}' |  cut -d " " -f2)
DOWNLOAD=$(echo "$DATA" | grep "Download:" | awk '{print $2}' |  cut -d " " -f2)
UPLOAD=$(echo "$DATA" | grep "Upload:" | awk '{print $2}' |  cut -d " " -f2)

echo "$DATE, $TIME, $PING, $DOWNLOAD, $UPLOAD" >> /home/droon/logid/speedtest-$DATE.csv
