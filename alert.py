import requests
import psutil
import time
import socket
from configparser import ConfigParser

# Reading configuration data from a file
config = ConfigParser()
config.read('config.conf')

API_KEY = config.get('Telegram', 'API_KEY')
CHAT_ID = config.get('Telegram', 'CHAT_ID')

SERVER_NAME = socket.gethostname()

# Function for sending a message in Telegram
def send_message(message):
    url = f"https://api.telegram.org/bot{API_KEY}/sendMessage?chat_id={CHAT_ID}&text={message}"
    requests.get(url)  # this sends the message
    print(message)

def main():
    disc_warning = False
    ram_warning = False
    cpu_warning = False
    
    send_message(f'⚙️ [ {SERVER_NAME} ]  >>>  alert.service is started!')
    
    while True:
        CPU_THRESHOLD = config.getint('Thresholds', 'CPU_THRESHOLD')
        RAM_THRESHOLD = config.getint('Thresholds', 'RAM_THRESHOLD')
        DISK_THRESHOLD = config.getint('Thresholds', 'DISK_THRESHOLD')
        
        # Check CPU usage
        cpu_percent = psutil.cpu_percent(interval=1)

        if cpu_warning and cpu_percent < CPU_THRESHOLD:
            send_message(f'🟢 [ {SERVER_NAME} ]  >>>  CPU {cpu_percent}%')
            cpu_warning = False

        if not cpu_warning and cpu_percent > CPU_THRESHOLD:
            send_message(f'🆘 [ {SERVER_NAME} ]  >>>  CPU {cpu_percent}%')
            cpu_warning = True


        # Check RAM usage
        ram_percent = psutil.virtual_memory().percent

        if ram_warning and ram_percent < RAM_THRESHOLD:
            send_message(f'🟢 [ {SERVER_NAME} ]  >>>  RAM {ram_percent}%')
            ram_warning = False

        if not ram_warning and ram_percent > RAM_THRESHOLD:
            send_message(f'🆘 [ {SERVER_NAME} ]  >>>  RAM {ram_percent}%')
            ram_warning = True


        # Check Disk usage
        disk_percent = psutil.disk_usage('/').percent
        
        if disc_warning and disk_percent < DISK_THRESHOLD:
            send_message(f'🟢 [ {SERVER_NAME} ]  >>>  Disk {disk_percent}%')
            disc_warning = False
        
        if not disc_warning and disk_percent > DISK_THRESHOLD:
            send_message(f'🆘 [ {SERVER_NAME} ]  >>>  Disk {disk_percent}%')
            disc_warning = True

        time.sleep(10)


if __name__ == '__main__':
    main()
