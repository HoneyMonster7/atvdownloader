#!/bin/bash

command -v rtmpdump >/dev/null 2>&1 || { echo >&2 "I require rtmpdump but it's not installed.  Aborting."; exit 1; }
command -v curl >/dev/null 2>&1 || { echo >&2 "I require curl but it's not installed.  Aborting."; exit 1; }

curl -s  www.atv.hu/musorok/hirado > /tmp/tmp.txt



dialog --title "ATV hirado" --menu "Melyik hiradot?" 25 75 15 `grep "videok/video" /tmp/tmp.txt | grep hirado | cut -d "\"" -f2 | uniq | head | awk 'BEGIN{i=0}{i++; print i " " $0}'` 2> /tmp/dialogresult.jnk

exitcode=$?

#echo $exitcode
hiradochosen=$(cat /tmp/dialogresult.jnk | cut -d% -f1)

echo "hiradochosen is $hiradochosen"

videolink=$(grep "videok/video" /tmp/tmp.txt | grep hirado | cut -d "\"" -f2 | uniq | head | sed "$hiradochosen""q;d")

#echo "videolink is $videolink"

curl -s www.atv.hu/$videolink > /tmp/videosite.tmp




#select whichvideo in `grep "videok/video" /tmp/tmp.txt | grep hirado | cut -d "\"" -f2 | uniq | head`
#do 
#	#echo "You picked the following video: $whichvideo"
#	curl -s www.atv.hu/$whichvideo > /tmp/videosite.tmp
#	break
#done

videochosen="$(grep mp4 /tmp/videosite.tmp | sed 's/.*data-streamurl=\"//'| cut -d "\"" -f1)"

streamserverIP="$(grep streamServer /tmp/videosite.tmp | cut -d "\"" -f2)"
echo "your chosen video's link is $videochosen and the ip of the streamserver is $streamserverIP"


rtmpdump -r rtmp://$streamserverIP/mediacache/_definst_/mp4/atv/$videochosen -o ~/output.mp4 -R


while [ $? != 0 ]; do
	sleep 2s
	rtmpdump -r rtmp://$streamserverIP/mediacache/_definst_/mp4/atv/$videochosen -o ~/output.mp4 -R --resume
done

notify-send "A hirado letoltese befejezodott."
rm -rf /tmp/videosite.tmp
rm /tmp/tmp.txt
rm /tmp/dialogresult.jnk
