
## Installation Script for the following software:
- [Syncthing](https://syncthing.net/)
- [Unbound](https://docs.pi-hole.net/guides/dns/unbound/)

---

### Execute: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/syncthing/install_syncthing.sh  
rpi/syncthing/install_syncthing.sh  
sudo rm -r rpi  

### URL:
localhost:8384

---

### Execute: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/unbound/install_unbound.sh  
rpi/unbound/install_unbound.sh
sudo rm -r rpi  

Finally, configure Pi-hole to use your recursive DNS server by specifying 127.0.0.1#5335 as the Custom DNS (IPv4)

---

### Execute: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/pihole/install_pihole.sh  
rpi/pihole/install_pihole.sh
sudo rm -r rpi  

---

### Execute: 
git clone https://github.com/zlServiceZ/rpi.git  
chmod +x rpi/config/disable_led.sh  
rpi/config/disable_led.sh
sudo rm -r rpi  

---

