The script notifies in Telegram when the server resources exceed the specified threshold values ​​for CPU, RAM and Disk. To install, just run the script and enter `telegram_bot_token` and `chat_id` of the group where you want to send notifications

## Install
##### 1. Run the script
```bash
source <(curl -s https://raw.githubusercontent.com/NodersUA/monitoring/main/setup.sh)
```

##### 2. Enter your TELEGRAM_API_KEY
[How to get Telegram bot API token](https://www.siteguarding.com/en/how-to-get-telegram-bot-api-token)

##### 3. Enter your MONITORING_CHAT_ID
[How to get a group chat id?](https://www.siteguarding.com/en/how-to-get-telegram-bot-api-token)

## Configuration
If you want to change the threshold values ​​then edit the `config.conf` file in the `monitoring` directory
```bash
nano $HOME/monitoring/config.conf
```

## Useful Commands
```bash
# Check logs
journalctl -u alert -f -o cat
```
```bash
# Restart
systemctl restart alert
```
```bash
# Stop
systemctl stop alert
```

## Delete
```bash
systemctl stop alert
rm /etc/systemd/system/alert.service
rm -rf $HOME/monitoring
```
