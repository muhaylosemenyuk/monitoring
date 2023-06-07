import requests
import psutil
import time
import socket

TOKEN = "6214809730:AAEliJJGNqxN9VngxjQb2bGJ0aJIF9XMNCM"
chat_id = "-908385158"

server_name = socket.gethostname()

WARNING_THRESHOLD = {
    'cpu': 90,  # percent
    'ram': 90,  # percent
    'disk': 90,  # percent
}

# Function for sending a message in Telegram
def send_message(message):
    url = f"https://api.telegram.org/bot{TOKEN}/sendMessage?chat_id={chat_id}&text={message}"
    requests.get(url)  # this sends the message
    print(message)

def main():
    disc_warning = False
    ram_warning = False
    cpu_warning = False
    
    while True:
        # Check CPU usage
        cpu_percent = psutil.cpu_percent(interval=1)

        if cpu_warning and cpu_percent < WARNING_THRESHOLD['cpu']:
            send_message(f'🔥 [ {server_name} ]  >>>  CPU {cpu_percent}%')
            cpu_warning = False

        if not cpu_warning and cpu_percent > WARNING_THRESHOLD['cpu']:
            send_message(f'🆘 [ {server_name} ]  >>>  CPU {cpu_percent}%')
            cpu_warning = True


        # Check RAM usage
        ram_percent = psutil.virtual_memory().percent

        if ram_warning and ram_percent < WARNING_THRESHOLD['ram']:
            send_message(f'🔥 [ {server_name} ]  >>>  RAM {ram_percent}%')
            ram_warning = False

        if not ram_warning and ram_percent > WARNING_THRESHOLD['ram']:
            send_message(f'🆘 [ {server_name} ]  >>>  RAM {ram_percent}%')
            ram_warning = True


        # Check Disk usage
        disk_percent = psutil.disk_usage('/').percent
        
        if disc_warning and disk_percent < WARNING_THRESHOLD['disk']:
            send_message(f'🔥 [ {server_name} ]  >>>  Disk {disk_percent}%')
            disc_warning = False
        
        if not disc_warning and disk_percent > WARNING_THRESHOLD['disk']:
            send_message(f'🆘 [ {server_name} ]  >>>  Disk {disk_percent}%')
            disc_warning = True

        time.sleep(10)


if __name__ == '__main__':
    main()
