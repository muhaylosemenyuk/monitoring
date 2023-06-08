#!/bin/bash

# Update the repositories
echo -e "        \e[1m\e[32m2. Update the repositories--> \e[0m" && sleep 1
sudo apt update && apt upgrade -y
sudo apt install pip -y

#=======================================================================

# Clone repository
echo -e "        \e[1m\e[32m2. Clone repository--> \e[0m" && sleep 1
cd $HOME && git clone https://github.com/NodersUA/monitoring/tree/muhaylosemenyuk-patch-1
cd monitoring && pip install -r requirements.txt

#=======================================================================

# Create config.conf
echo -e "        \e[1m\e[32m2. Create config.conf--> \e[0m" && sleep 1

if [ -z "$TELEGRAM_API_KEY" ]; then
  echo "*********************"
  echo -e "\e[1m\e[32m	Enter your TELEGRAM_API_KEY:\e[0m"
  echo "*********************"
  read TELEGRAM_API_KEY
  echo "==================================================="
  echo 'export TELEGRAM_API_KEY='$TELEGRAM_API_KEY >> $HOME/.bash_profile
  source $HOME/.bash_profile
fi

if [ -z "$MONITORING_CHAT_ID" ]; then
  echo "*********************"
  echo -e "\e[1m\e[32m	Enter your MONITORING_CHAT_ID:\e[0m"
  echo "*********************"
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
CPU_THRESHOLD = 90
RAM_THRESHOLD = 90
DISK_THRESHOLD = 90
EOF

echo "*****************************"
echo -e "\e[1m\e[32m CPU_THRESHOLD = 90 \e[0m"
echo -e "\e[1m\e[32m RAM_THRESHOLD = 90\e[0m"
echo -e "\e[1m\e[32m DISK_THRESHOLD = 90 \e[0m"
echo "*****************************"
sleep 1

#=======================================================================

# Run Monitoring service file
echo -e "        \e[1m\e[32m2. Create Monitoring service file--> \e[0m" && sleep 1
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

sudo journalctl -u alert -f -o cat
