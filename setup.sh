#!/bin/bash

# Logo
curl -s https://raw.githubusercontent.com/NodersUA/Scripts/main/logo.sh | bash

CPU_THRESHOLD=95
RAM_THRESHOLD=95
DISK_THRESHOLD=90

CPU_NOTIFICATION=False
RAM_NOTIFICATION=False
DISC_NOTIFICATION=True

# Update the repositories
echo -e "\e[1m\e[32m ****** Update the repositories ****** \e[0m" && sleep 1
sudo apt update && apt upgrade -y
sudo apt install pip -y

#=======================================================================

# Clone repository
echo -e "\e[1m\e[32m ***** Clone repository ***** \e[0m" && sleep 1
cd $HOME && git clone https://github.com/NodersUA/monitoring
cd monitoring && pip install -r requirements.txt

#=======================================================================

# Create config.conf
echo -e "\e[1m\e[32m ****** Create config.conf ****** \e[0m" && sleep 1

if [ -z "$TELEGRAM_API_KEY" ]; then
  echo "*********************"
  echo -e "\e[1m\e[32m	Enter your TELEGRAM_API_KEY:\e[0m"
  read TELEGRAM_API_KEY
  echo "==================================================="
  echo 'export TELEGRAM_API_KEY='$TELEGRAM_API_KEY >> $HOME/.bash_profile
  source $HOME/.bash_profile
fi

if [ -z "$MONITORING_CHAT_ID" ]; then
  echo "*********************"
  echo -e "\e[1m\e[32m	Enter your MONITORING_CHAT_ID:\e[0m"
  read MONITORING_CHAT_ID
  echo "==================================================="
  echo 'export MONITORING_CHAT_ID='$MONITORING_CHAT_ID >> $HOME/.bash_profile
  source $HOME/.bash_profile
fi

tee $HOME/monitoring/config.conf > /dev/null <<EOF
[Telegram]
API_KEY = $TELEGRAM_API_KEY
CHAT_ID = $MONITORING_CHAT_ID

[Thresholds]
CPU_THRESHOLD = $CPU_THRESHOLD
RAM_THRESHOLD = $RAM_THRESHOLD
DISK_THRESHOLD = $DISK_THRESHOLD

[Notifications]
CPU_NOTIFICATION = $CPU_NOTIFICATION
RAM_NOTIFICATION = $RAM_NOTIFICATION
DISC_NOTIFICATION = $DISC_NOTIFICATION
EOF

echo "*****************************"
echo -e "\e[1m\e[32m CPU_THRESHOLD  = $CPU_THRESHOLD \e[0m"
echo -e "\e[1m\e[32m RAM_THRESHOLD  = $RAM_THRESHOLD \e[0m"
echo -e "\e[1m\e[32m DISK_THRESHOLD = $DISK_THRESHOLD \e[0m"
echo "*****************************"
sleep 1

#=======================================================================

# Run Monitoring service file
echo -e "\e[1m\e[32m ****** Create Monitoring service file ****** \e[0m" && sleep 1
sudo tee /etc/systemd/system/alert.service > /dev/null <<EOF
[Unit]
Description=Monitoring Service
After=network.target

[Service]
User=$USER
ExecStart=/usr/bin/python3 $HOME/monitoring/alert.py
WorkingDirectory=$HOME/monitoring

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable alert
sudo systemctl start alert

echo '=============== SETUP FINISHED ==================='
echo -e "\e[1m\e[32m Check logs ===> journalctl -u alert -f -o cat \e[0m"
echo -e "\e[1m\e[32m Restart ======> systemctl restart alert \e[0m"
echo "*****************************"

sudo journalctl -u alert -f -o cat
