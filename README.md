# Slack and SNS Notification for Zabbix Monitoring

## Getting Started
This enables slack and AWS SNS notification for Zabbix monitoring.

### Prerequisites
1. Create your own Slack Webhook URL and channel where the slack alerts will be sent
2. Create SNS topic and subscriptions
3. IAM user with SNS publish policy attached. The Access Key ID and Secret Access Key should be configured on the server.
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1509939905000",
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": [
                "arn:aws:sns:ap-northeast-1:xxxxxx:ZabbixNotif"
            ]
        }
    ]
}
```
4. Copy the script and provide the required values (webhook URL, channel, ARNtopic..)
5. Configure your Zabbix UI:
```
Under Administration -> Media Types
Create a media type and use the script that should be placed on your internal custom script in your zabbix server (see zabbix_server.conf for details - usually under /usr/lib/zabbix/alertscripts). 
Define the parameters you need on your script.
```

![alt tag](https://github.com/jjcpagtakhan/slack_sns_zabbix/blob/master/img/1-zabbix-mediatype.png)

```
Under Administration -> Users
Create a new user, put to read only group and apply the media you previously added then select your preferred alert severity.
```

![alt tag](https://github.com/jjcpagtakhan/slack_sns_zabbix/blob/master/img/2-zabbix-user.png)

![alt tag](https://github.com/jjcpagtakhan/slack_sns_zabbix/blob/master/img/3-zabbix-media.png)

![alt tag](https://github.com/jjcpagtakhan/slack_sns_zabbix/blob/master/img/4-zabbix-permission.png)

```
Under Configuration -> Actions
Create new actions and add your conditions. 
Under Operations tab, add what you want to receive under subject and message parameters.
(ex. Default Subject - "{TRIGGER.NAME} on {HOST.NAME} ({IPADDRESS}); Default message - {TRIGGER.STATUS}".
Setup operations to send alert to your created user using also your newly created media and send the recovery to those who were notified by the problem.
```

![alt tag](https://github.com/jjcpagtakhan/slack_sns_zabbix/blob/master/img/5-zabbix-action.png)

![alt tag](https://github.com/jjcpagtakhan/slack_sns_zabbix/blob/master/img/6-zabbix-ops.png)

![alt tag](https://github.com/jjcpagtakhan/slack_sns_zabbix/blob/master/img/7-zabbix-rec.png)

5. Ensure the script and log file (so the logging will work) is owned by zabbix user. Also, make sure that zabbix or the instance itself has permission to do SNS publish, else, SNS publish will fail.

## Running the tests 
You may do manual testing to check if you'll be able to receive the notification on the account you used or just wait for real alerts to come, you'll see the actions status if it has successfully run or has failed.

### Manual testing
The first input will be the subject and the second input is for the message (OK/PROBLEM/RECOVERED/RECOVERY)
``` 
$ chmod a+x notif.sh
$ ./notif.sh "This is a test notification" PROBLEM
```

### No notification received
Check out the log file to see if the alert has satisfied the defined conditions. Verify account permissions, channel and URLs. Do neccessary adjustments if needed.

## Acknowledgement
This work is referenced from https://github.com/ericoc/zabbix-slack-alertscript
