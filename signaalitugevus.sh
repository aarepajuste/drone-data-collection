#!/bin/bash
#./huawei.py | grep -E 'rsrq|rsrp|rssi|sinr|workmode'
#(u'workmode', u'LTE')
#(u'rsrq', u'-5dB') Reference Signal Received Quality
#(u'rsrp', u'-101dBm') Reference Signal Received Power
#(u'rssi', u'-77dBm') Received Signal Strength Indication
#(u'sinr', u'11dB') Signal to Noise Ratio

TIME=$(date | awk '{print $4}')
DATE=$(date +%d-%m-%Y) 

#Kontrollib kas fail eksisteerib, et panna esimese rea paika csv failis, kui eksisteerib siis ei puutu.
if [ -e /home/droon/logid/signaalitugevus-$DATE.csv ]
then
	echo "Logifailid eksisteerivad, kirjutan informatsiooni..."
else
	echo "Logifailid ei eksisteeri. Tekitan csv faili esimese reaga ning kirjutan ülejäänud informatsiooni..."
	touch /home/droon/logid/signaalitugevus-$DATE.csv
	echo "DATE, TIME, WORKMODE, RSRQ, RSRP, RSSI, SINR, PING1, PING2" >> /home/droon/logid/signaalitugevus-$DATE.csv
fi

#Võtab skriptiga informatsiooni modemist
DATA=$(python /home/droon/huawei.py | grep -E 'rsrq|rsrp|rssi|sinr|workmode')

#Puhastab informatsiooni
WORKMODE=$(echo "$DATA" | grep "'workmode', u'" | awk '{print $2}' |  cut -d "'" -f2)
RSRQ=$(echo "$DATA" | grep "'rsrq', u'" | awk '{print $2}' |  cut -d "'" -f2)
RSRP=$(echo "$DATA" | grep "'rsrp', u'" | awk '{print $2}' |  cut -d "'" -f2)
RSSI=$(echo "$DATA" | grep "'rssi', u'" | awk '{print $2}' |  cut -d "'" -f2)
SINR=$(echo "$DATA" | grep "'sinr', u'" | awk '{print $2}' |  cut -d "'" -f2)

#Pingib
PING1=$(ping -s 1442 -c 4 213.100.249.47 | tail -1| awk '{print $4}' | cut -d '/' -f 2)
PING2=$(ping -s 1442 -c 4 ilm.eava.ee | tail -1| awk '{print $4}' | cut -d '/' -f 2)

#Kirjutab informatsiooni faili
echo "$DATE, $TIME, $WORKMODE, $RSRQ, $RSRP, $RSSI, $SINR, $PING1, $PING2" >> /home/droon/logid/signaalitugevus-$DATE.csv

#Traceroute informatsioon
TRACERT=$(traceroute 213.100.249.47)
echo "$TIME" >> /home/droon/logid/traceroutelogia-$DATE.txt
echo "$TRACERT" >> /home/droon/logid/traceroutelogia-$DATE.txt
echo "" >> /home/droon/logid/traceroutelogia-$DATE.txt
echo "" >> /home/droon/logid/traceroutelogia-$DATE.txt

TRACERT2=$(traceroute ilm.eava.ee)
echo "$TIME" >> /home/droon/logid/traceroutelogia-$DATE.txt
echo "$TRACERT2" >> /home/droon/logid/traceroutelogia-$DATE.txt
echo "" >> /home/droon/logid/traceroutelogia-$DATE.txt
echo "" >> /home/droon/logid/traceroutelogia-$DATE.txt



echo "Informatsioon kogutud ja salvestatud."
