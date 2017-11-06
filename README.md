This enables slack and AWS SNS notification for Zabbix monitoring.

What you need to configure:
1. Create your own Slack Webhook URL and channel where the slack alerts will be sent
2. Create SNS topic and subscriptions
3. Copy the script and provide the required values (webhook URL, channel, ARNtopic..)
4. Configure your Zabbix UI:
> Under Administration -> Media Types, create a media type and use the script that should be placed on your internal custom script in your zabbix server (see zabbix_server.conf for details). Define the parameters you need on your script.
> Under Admnistration -> Users, create a new user and apply the media you previously added then select your preferred alert severity
> Under Configuration -> Actions, create new actions and add your conditions. Under Operations tab, add what you want to receive under subject and message parameters. (ex. Default Subject - "{TRIGGER.NAME} on {HOST.NAME} ({IPADDRESS}); Default message - {TRIGGER.STATUS}". Setup operations to send alert to your created user using also your newly created media and send the recovery to those who were notified by the problem.
5. Ensure the script is owned by zabbix user and that zabbix has permission to do SNS publish, else, AWS SNS won't work.

