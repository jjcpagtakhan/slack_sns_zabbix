#!/bin/bash

# will initiate slack/sns email alert once alert severity is >=High
# reference - https://github.com/ericoc/zabbix-slack-alertscript

# For Slack web-hook URL and user 
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
WEBHOOK='https://hooks.slack.com/services/yourownwebhookurl'
USER='Zabbix'
TO='#yourownslackchannel'
# Add these parameters on your created media type in Zabbix UI
SUBJECT="$1" # Contains Zabbix alert subject, Host and IP
MESSAGE="$2" # Trigger status: PROBLEM/OK/RECOVERED
CLEARED='^RECOVER(Y|ED)?$'
ZABBIX_MESSAGE="ZABBIX AWS - ${SUBJECT} : $2"
ARN="arn:aws:sns:ap-northeast-1:yourownSNStopic"
LOG=/var/log/zabbix_notif/notif_`date +%Y%m%d`.log

function validate {
if [ $? -eq 0 ]; then
        echo "`date -u` SNS notif successful"
else
        echo "`date -u` SNS notif failed!"
fi
}


function notif {
# Customize icon and send SNS message accordingly
if [[ "$MESSAGE" =~ ${CLEARED} ]]; then
	ICON=':ghost:'
	aws sns publish --topic-arn $ARN --message "$ZABBIX_MESSAGE" --subject "Zabbix AWS Alert Notification - [RECOVERED]"
        validate
	echo "ENTERED CLEARED"
elif [ "$MESSAGE" == 'OK' ]; then
	ICON=':ghost:'
	aws sns publish --topic-arn $ARN --message "$ZABBIX_MESSAGE" --subject "Zabbix AWS Alert Notification - [OK]"
        validate
	echo "ENTERED OK"
elif [ "$MESSAGE" == 'PROBLEM' ]; then
	ICON=':ghost:'
	aws sns publish --topic-arn $ARN --message "$ZABBIX_MESSAGE" --subject "Zabbix AWS Alert Notification - [PROBLEM]"
        validate
	echo "ENTERED PROBLEM"
else
	ICON=':ghost:'
	aws sns publish --topic-arn $ARN --message "$ZABBIX_MESSAGE" --subject "Zabbix AWS Alert Notification - [UNCATERGORIZED]"
        validate
	echo "ENTERED NONE"
fi

# Build JSON payload and send it as a POST request to the Slack incoming web-hook URL
PAYLOAD="payload={\"channel\": \"${TO//\"/\\\"}\", \"username\": \"${USER//\"/\\\"}\", \"text\": \"${ZABBIX_MESSAGE//\"/\\\"}\", \"icon_emoji\": \"${ICON}\"}"
curl -s -m 5 --data-urlencode "${PAYLOAD}" $WEBHOOK
if [ $? -eq 0 ]; then
	echo "`date -u` Slack notif successful"
else
	echo "`date -u` Slack notif failed!"
fi
}

function log {
	exec &>> $LOG
}

log
notif

