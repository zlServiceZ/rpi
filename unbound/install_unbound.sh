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

# configure DoH
sudo apt install nginx -y
sudo systemctl start nginx
# generieren der Zertifikate
sudo apt install software-properties-common -y
sudo apt-get install certbot -y
sudo apt-get install python3-certbot-apache -y
sudo apt update
sudo certbot --nginx -d localhost

server {
    listen 443 ssl http2;
    server_name localhost;

    ssl_certificate /etc/nginx/certs/example.com.crt; # Pfad zu Ihrem SSL-Zertifikat
    ssl_certificate_key /etc/nginx/certs/example.com.key; # Pfad zum privaten Schlüssel

    location /dns-query {
        proxy_pass https://127.0.0.1:5353;
        proxy_ssl_verify off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}


sudo systemctl restart nginx
sudo ufw allow 443/tcp

# Überprüfe, ob die Datei setupVars.conf existiert
if [ -f /etc/pihole/setupVars.conf ]; then
    # Überprüfe und bearbeite PIHOLE_DNS_1
    if grep -q "^PIHOLE_DNS_1=" /etc/pihole/setupVars.conf; then
        if ! grep -q "^PIHOLE_DNS_1=127.0.0.1#5353" /etc/pihole/setupVars.conf; then
            sed -i 's/^PIHOLE_DNS_1=.*/PIHOLE_DNS_1=127.0.0.1#5353/' /etc/pihole/setupVars.conf
            echo "PIHOLE_DNS_1 auf 127.0.0.1#5353 geändert"
        else
            echo "PIHOLE_DNS_1 ist bereits auf 127.0.0.1#5353 gesetzt"
        fi
    else
        echo "PIHOLE_DNS_1=127.0.0.1#5353" >> /etc/pihole/setupVars.conf
        echo "PIHOLE_DNS_1 mit Wert 127.0.0.1#5353 erstellt"
    fi

    # Überprüfe und bearbeite DNS_FQDN_REQUIRED
    if grep -q "^DNS_FQDN_REQUIRED=false" /etc/pihole/setupVars.conf; then
        sed -i 's/^DNS_FQDN_REQUIRED=false/DNS_FQDN_REQUIRED=true/' /etc/pihole/setupVars.conf
        echo "DNS_FQDN_REQUIRED von false auf true geändert"
    elif ! grep -q "^DNS_FQDN_REQUIRED=" /etc/pihole/setupVars.conf; then
        echo "DNS_FQDN_REQUIRED=true" >> /etc/pihole/setupVars.conf
        echo "DNS_FQDN_REQUIRED=true erstellt"
    else
        echo "DNS_FQDN_REQUIRED ist bereits vorhanden"
    fi

    # Überprüfe und bearbeite DNS_BOGUS_PRIV
    if grep -q "^DNS_BOGUS_PRIV=false" /etc/pihole/setupVars.conf; then
        sed -i 's/^DNS_BOGUS_PRIV=false/DNS_BOGUS_PRIV=true/' /etc/pihole/setupVars.conf
        echo "DNS_BOGUS_PRIV von false auf true geändert"
    elif ! grep -q "^DNS_BOGUS_PRIV=" /etc/pihole/setupVars.conf; then
        echo "DNS_BOGUS_PRIV=true" >> /etc/pihole/setupVars.conf
        echo "DNS_BOGUS_PRIV=true erstellt"
    else
        echo "DNS_BOGUS_PRIV ist bereits vorhanden"
    fi
else
    echo "Datei setupVars.conf nicht vorhanden"
fi


sudo pihole restartdns

