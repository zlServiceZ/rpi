
## Installation Script for the following software:
- [Syncthing](https://syncthing.net/)
- [Unbound](https://docs.pi-hole.net/guides/dns/unbound/)

---

### Disable Leds: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/config/disable_led.sh  
rpi/config/disable_led.sh
sudo rm -r rpi  

---

### Save Power: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/config/save_power.sh  
rpi/config/save_power.sh  
sudo rm -r rpi  

---

### Home Assistant Supervisor: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/home_assistant/install_home_assistant1.sh  
chmod +x rpi/home_assistant/install_home_assistant2.sh 
rpi/home_assistant/install_home_assistant1.sh
# reboot
rpi/home_assistant/install_home_assistant2.sh
sudo rm -r rpi  

#### Url:
localhost:8123

---

### Kodi: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/kodi/install_kodi.sh  
rpi/kodi/install_kodi.sh  
sudo rm -r rpi

---

### AdGuard Home: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/adguard_home/install_adguard_home.sh  
rpi/adguard_home/install_adguard_home.sh  
sudo rm -r rpi  

#### URL:
localhost:3000

---

### Syncthing: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/syncthing/install_syncthing.sh  
rpi/syncthing/install_syncthing.sh  
sudo rm -r rpi  

#### URL:
localhost:8384

---

### pi-hole: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/pihole/install_pihole.sh  
rpi/pihole/install_pihole.sh
sudo rm -r rpi  

#### Url:
localhost/admin

---

### Unbound (with DoH): 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/unbound/install_unbound.sh  
rpi/unbound/install_unbound.sh
sudo rm -r rpi  

---


