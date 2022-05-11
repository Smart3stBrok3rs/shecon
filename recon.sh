#!/bin/bash
echo "-------------------in the name of allah---------------"
echo "------------------------------------------------------"
echo "------------------recon will be starting--------------"
echo "------------------------------------------------------"
echo "------------------------Created By -------------------"
echo "------------------------------------------------------"
echo "------------------twitter:@SmartestBroker-------------"
echo "------------------------------------------------------"
sleep 1
ls /usr/bin > .requirment.txt
if [ $(grep 'crobat' .requirment.txt ) == "crobat" ] 
then
echo "crobat installed------------------------------------ok"
else
echo "crobat not installed check requirment.txt file" && exit 
fi 
if [ $(grep 'gospider' .requirment.txt ) == "gospider" ] 
then
echo "gospider installed----------------------------------ok"
else
echo "gospider not installed check requirment.txt file" && exit 
fi
if [ $(grep 'httpx-toolkit' .requirment.txt ) == "httpx-toolkit" ] 
then
echo "httpx-toolkit installed-----------------------------ok"
else
echo "crobat not installed check requirment.txt file" && exit 
fi 
if [ $(grep 'jq' .requirment.txt ) == "jq" ] 
then
echo "jq installed----------------------------------------ok"
else
echo "jq not installed check requirment.txt file" && exit 
fi
sleep 1
rm -rf .requirment.txt
sleep 1
echo "--------------------recon starting--------------------"
crobat -s $1 > reconProjectsubdomains.txt
tr '.' '\n' < reconProjectsubdomains.txt | sort -u > wordlists.txt
curl -sk "https://crt.sh/?q=$1&output=json" | jq -r '.[].name_value' | tr '*' '\n' | sort -u >> reconProjectsubdomains.txt
sleep 10
sed -i '/^$/d' reconProjectsubdomains.txt 
cat reconProjectsubdomains.txt | sort -u > subdomains.txt
sleep 1 
rm -rf reconProjectsubdomains.txt
echo "Checking the $1 subdomains hosts"
sleep 2
for suba in $(cat subdomains.txt)
    do 
        x=$(echo $suba | httpx-toolkit -silent -no-color -status-code )
        if [ -z "$x" ]
        then
        x=$(echo "NotResponse")
        echo $suba $x >> result.txt
        else 
        echo $x >> result.txt
        fi
    done
sleep 1
for subb in $(cat subdomains.txt)
    do 
        x=$(echo $subb | httpx-toolkit -silent -no-color -mc 200)
        echo $x >> Temporary.txt
    done
sed -i '/^$/d' Temporary.txt
echo "Url Crawling from *.$1"
for subw in $(cat Temporary.txt)
    do 
        #gospider running line 'grep' is for made useful urls 
        gospider -s $subw -t 20 -d 1 -c 10 --other-source --blacklist ".(js)" | grep -Eo "(([a-zA-Z][a-zA-Z0-9+-.]*\:\/\/)|mailto|data\:)([a-zA-Z0-9\.\&\/\?\:@\+-\_=#%;,])*" | sort -u >> AllOfUrls.txt
        sleep 1
    done
echo "mail Extracting from *.$1 $(cat AllOfUrls.txt | wc -l ) Http request for this section"

for subc in $(cat AllOfUrls.txt)
    do
        curl -ks -H 'Referer: http://127.0.0.1/' -H 'X-Forwarded-For: 127.0.0.1' $subc | grep -Eo "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" >> MailsExtracted.txt
        sed -i '/^$/d' MailsExtracted.txt
	done
rm -rf Temporary.txt
echo "----------------------------------------------finished" && exit