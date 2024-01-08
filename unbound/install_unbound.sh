#!/bin/bash

# Paketaktualisierung und Installation von Unbound
sudo apt update
sudo apt upgrade -y
sudo apt install unbound -y

# Erstellen der Konfigurationsdatei als Root-Benutzer
sudo bash -c 'cat <<EOF > /etc/unbound/unbound.conf.d/pihole.conf
server:
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # ... (and so on for all the configurations)

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10
EOF'

# signal FTL to adhere to this limit.
if grep -qxF 'edns-packet-max=1232' /etc/dnsmasq.d/99-edns.conf; then
    echo "Der Eintrag edns-packet-max=1232 existiert bereits in der Datei."
else
    echo "Der Eintrag edns-packet-max=1232 existiert nicht in der Datei."
    # Hinzufügen des Eintrags, falls er noch nicht existiert
    echo "edns-packet-max=1232" | sudo tee -a /etc/dnsmasq.d/99-edns.conf
fi


sudo service unbound restart

# Überprüfen, ob das Schreiben erfolgreich war
if [ $? -eq 0 ]; then
    echo "Konfigurationsdatei wurde erfolgreich erstellt."
else
    echo "Fehler beim Erstellen der Konfigurationsdatei."
fi
