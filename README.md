
## Installation Script for the following software:
- [Syncthing](https://syncthing.net/)
- [Unbound](https://docs.pi-hole.net/guides/dns/unbound/)

---

### Syncthing: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/syncthing/install_syncthing.sh  
rpi/syncthing/install_syncthing.sh  
sudo rm -r rpi  

#### URL:
localhost:8384

---

### Unbound (with DoH): 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/unbound/install_unbound.sh  
rpi/unbound/install_unbound.sh
sudo rm -r rpi  

---

### pi-hole: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/pihole/install_pihole.sh  
rpi/pihole/install_pihole.sh
sudo rm -r rpi  

#### Url:
localhost/admin

---

### Disable Leds: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/config/disable_led.sh  
rpi/config/disable_led.sh
sudo rm -r rpi  

---

### Home Assistant Supervisor: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/home_assistant/install_home_assistant.sh  
rpi/home_assistant/install_home_assistant.sh
sudo rm -r rpi  

#### Url:
localhost:8123

---


