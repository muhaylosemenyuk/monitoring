The script notifies in Telegram when the server resources exceed the specified threshold values ​​for CPU, RAM and Disk. To install, just run the script and enter `telegram_bot_token` and `chat_id` of the group where you want to send notifications

## Install
##### 1. Run the script
```bash
source <(curl -s https://raw.githubusercontent.com/NodersUA/monitoring/main/setup.sh)
```

##### 2. Enter your TELEGRAM_API_KEY
[How to get Telegram bot API token](https://www.siteguarding.com/en/how-to-get-telegram-bot-api-token)

##### 3. Enter your MONITORING_CHAT_ID
[How to get a group chat id?](https://stackoverflow.com/questions/32423837/telegram-bot-how-to-get-a-group-chat-id)

## Configuration
If you want to change the threshold values ​​then edit the `config.conf` file in the `monitoring` directory
```bash
nano ~/monitoring/config.conf
```

You can also change the threshold values ​​with commands
```bash
sed -i 's/CPU_THRESHOLD = .*/CPU_THRESHOLD = 80/g' ~/monitoring/config.conf
sed -i 's/RAM_THRESHOLD = .*/RAM_THRESHOLD = 80/g' ~/monitoring/config.conf
sed -i 's/DISC_THRESHOLD = .*/DISC_THRESHOLD = 80/g' ~/monitoring/config.conf
```

You can also turn notifications on or off with commands
```bash
# On notifications
sed -i 's/CPU_NOTIFICATION = .*/CPU_NOTIFICATION = True/g' ~/monitoring/config.conf
sed -i 's/RAM_NOTIFICATION = .*/RAM_NOTIFICATION = True/g' ~/monitoring/config.conf
sed -i 's/DISC_NOTIFICATION = .*/DISC_NOTIFICATION = True/g' ~/monitoring/config.conf

# Off notifications
sed -i 's/CPU_NOTIFICATION = .*/CPU_NOTIFICATION = False/g' ~/monitoring/config.conf
sed -i 's/RAM_NOTIFICATION = .*/RAM_NOTIFICATION = False/g' ~/monitoring/config.conf
sed -i 's/DISC_NOTIFICATION = .*/DISC_NOTIFICATION = False/g' ~/monitoring/config.conf
```

## Useful Commands
```bash
# Check logs
journalctl -u alertd -f -o cat
```
```bash
# Restart
systemctl restart alertd
```
```bash
# Stop
systemctl stop alertd
```

## Update
```bash
cp ~/monitoring/config.conf ~/config_temp.conf
systemctl stop alertd && cd ~/monitoring
git fetch && git reset --hard
git pull
mv -f ~/config_temp.conf ~/monitoring/config.conf
pip install -r requirements.txt
systemctl start alertd
```

## Delete
```bash
systemctl stop alertd
rm /etc/systemd/system/alertd.service
rm -rf $HOME/monitoring
```

### How to rename your hostname
```bash
# Rename your server
sudo nano /etc/hostname
```

```bash
# Replace all the old names in the file with the new ones
sudo nano /etc/hosts
```

```bash
sudo reboot
```
