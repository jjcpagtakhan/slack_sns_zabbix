# Slack and SNS notification for Zabbix Monitoring

## Getting Started
This enables slack and AWS SNS notification for Zabbix monitoring.

### Prerequisites
1. Create your own Slack Webhook URL and channel where the slack alerts will be sent
2. Create SNS topic and subscriptions
3. Copy the script and provide the required values (webhook URL, channel, ARNtopic..)
4. Configure your Zabbix UI:
```
Under Administration -> Media Types
Create a media type and use the script that should be placed on your internal custom script in your zabbix server (see zabbix_server.conf for details). 
Define the parameters you need on your script.
```
```
Under Admnistration -> Users
Create a new user and apply the media you previously added then select your preferred alert severity
```
```
Under Configuration -> Actions
Create new actions and add your conditions. 
Under Operations tab, add what you want to receive under subject and message parameters.
(ex. Default Subject - "{TRIGGER.NAME} on {HOST.NAME} ({IPADDRESS}); Default message - {TRIGGER.STATUS}".
Setup operations to send alert to your created user using also your newly created media and send the recovery to those who were notified by the problem.
```
5. Ensure the script and log file (so the logging will work) is owned by zabbix user. Also, make sure that zabbix or the instance itself has permission to do SNS publish, else, SNS publish will fail.

## Running the tests 
You may do manual testing to check if you'll be able to receive the notification on the account you used or just want to real alerts to come, you'll see the actions status if it has successfully run or has failed.

### Manual testing
The first input will be the subject and the second input is for the message (OK/PROBLEM/RECOVERED/RECOVERY)
``` 
$ chmod a+x script.sh
$ ./script.sh "This is a test notification" PROBLEM
```

## Acknowledgement
This work is referenced from https://github.com/ericoc/zabbix-slack-alertscript
