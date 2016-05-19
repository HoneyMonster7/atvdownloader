# atvdownloader
Downloading one of the latest Hirado(News) from the hungarian ATV-s website. 

Uses rtmpdump curl and dialog. 

My home connections breaks for a split second very often and this makes the online player drop the stream. Then I have to refresh the page and find where was I before it broke. 

This script gets the list of the last 10 instances of Hirado, you can choose which one to download in a dialog setting. 

The file will be downloaded to your home folder under the name output.mp4, I'll add the possibility of changing the name. 

If the stream breaks, the script will re-try after a 3 second wait. 

Once about 2 minutes have been downloaded you can start watching output.mp4 in VLC or similar. Depending on how busy ATV-s servers are and your downstream speeds you might have to wait longer. 

