#!/bin/bash

# Paketaktualisierung und Installation von Unbound
wget https://nlnetlabs.nl/downloads/unbound/unbound-latest.tar.gz
tar xzf unbound-latest.tar.gz
sudo rm -r unbound-latest.tar.gz
cd unbound*

sudo apt update
sudo apt upgrade -y
sudo apt install -y libssl-dev libexpat1-dev build-essential bison flex libnghttp2-dev

./configure --with-libnghttp2
make
sudo make install

# generate ssl certificates
source "$HOME/rpi/tools/generate_certs.sh"

# ToDo: vorher überprüfen, ob die Datei exisitert, vlt eigenes scirpt schreiben, welches so etwas allgemein überprüft und überall anwenden
# Konfiguration für DoH in Unbound
sudo bash -c 'cat << EOF > /usr/local/etc/unbound/unbound.conf
server:
    interface: 127.0.0.1@443
    tls-service-key: "/etc/ssl/certs/key.pem"
    tls-service-pem: "/etc/ssl/certs/cert.pem"
EOF'

sudo unbound

# Überprüfen, ob schon vorhnaden
# Erstellen der Konfigurationsdatei als Root-Benutzer
sudo mkdir /etc/unbound
sudo mkdir /etc/unbound/unbound.conf.d
sudo bash -c "cat << EOF > /etc/unbound/unbound.conf.d/pi-hole.conf
server:
    # If no logfile is specified, syslog is used
    # logfile: \"/var/log/unbound/unbound.log\"
    verbosity: 0

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to yes if you have IPv6 connectivity
    do-ip6: no

    # You want to leave this to no unless you have *native* IPv6. With 6to4 and
    # Terredo tunnels your web browser should favor IPv4 for the same reasons
    prefer-ip6: no

    # Use this only when you downloaded the list of primary root servers!
    # If you use the default dns-root-data package, unbound will find it automatically
    #root-hints: \"/var/lib/unbound/root.hints\"

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    # IP fragmentation is unreliable on the Internet today, and can cause
    # transmission failures when large DNS messages are sent via UDP. Even
    # when fragmentation does work, it may not be secure; it is theoretically
    # possible to spoof parts of a fragmented DNS message, without easy
    # detection at the receiving end. Recently, there was an excellent study
    # >>> Defragmenting DNS - Determining the optimal maximum UDP response size for DNS <<<
    # by Axel Koolhaas, and Tjeerd Slokker (https://indico.dns-oarc.net/event/36/contributions/776/)
    # in collaboration with NLnet Labs explored DNS using real world data from the
    # the RIPE Atlas probes and the researchers suggested different values for
    # IPv4 and IPv6 and in different scenarios. They advise that servers should
    # be configured to limit DNS messages sent over UDP to a size that will not
    # trigger fragmentation on typical network links. DNS servers can switch
    # from UDP to TCP when a DNS response is too big to fit in this limited
    # buffer size. This value has also been suggested in DNS Flag Day 2020.
    edns-buffer-size: 1232

    # Perform prefetching of close to expired message cache entries
    # This only applies to domains that have been frequently queried
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10
EOF"

# signal FTL to adhere to this limit.
if grep -qxF "edns-packet-max=1232" /etc/dnsmasq.d/99-edns.conf; then
    echo "Der Eintrag edns-packet-max=1232 existiert bereits in der Datei."
else
  # Hinzufügen des Eintrags, falls er noch nicht existiert
    echo "edns-packet-max=1232" | sudo tee -a /etc/dnsmasq.d/99-edns.conf
fi

# Überprüfen, ob das Schreiben erfolgreich war
if [ $? -eq 0 ]; then
    echo "Konfigurationsdatei wurde erfolgreich erstellt."
else
    echo "Fehler beim Erstellen der Konfigurationsdatei."
fi


if [ -f /etc/pihole/setupVars.conf ]; then
    # Überprüfe und bearbeite PIHOLE_DNS_1
    if grep -q "^PIHOLE_DNS_1=" /etc/pihole/setupVars.conf; then
        if ! grep -q "^PIHOLE_DNS_1=127.0.0.1#5353" /etc/pihole/setupVars.conf; then
            sudo sed -i 's/^PIHOLE_DNS_1=.*/PIHOLE_DNS_1=127.0.0.1#5353/' /etc/pihole/setupVars.conf
            echo "PIHOLE_DNS_1 auf 127.0.0.1#5353 geändert"
        else
            echo "PIHOLE_DNS_1 ist bereits auf 127.0.0.1#5353 gesetzt"
        fi
    else
        echo "PIHOLE_DNS_1=127.0.0.1#5353" >> /etc/pihole/setupVars.conf
        echo "PIHOLE_DNS_1 mit Wert 127.0.0.1#5353 erstellt"
    fi

    # Lösche PIHOLE_DNS_2, PIHOLE_DNS_3 oder PIHOLE_DNS_4, falls vorhanden
    sudo sed -i '/^PIHOLE_DNS_2=/d; /^PIHOLE_DNS_3=/d; /^PIHOLE_DNS_4=/d' /etc/pihole/setupVars.conf

    # Überprüfe und bearbeite DNS_FQDN_REQUIRED
    if grep -q "^DNS_FQDN_REQUIRED=false" /etc/pihole/setupVars.conf; then
        sudo bash -c "sed -i 's/^DNS_FQDN_REQUIRED=false/DNS_FQDN_REQUIRED=true/' /etc/pihole/setupVars.conf"
        echo "DNS_FQDN_REQUIRED von false auf true geändert"
    elif ! grep -q "^DNS_FQDN_REQUIRED=" /etc/pihole/setupVars.conf; then
        echo "DNS_FQDN_REQUIRED=true" >> /etc/pihole/setupVars.conf
        echo "DNS_FQDN_REQUIRED=true erstellt"
    else
        echo "DNS_FQDN_REQUIRED ist bereits vorhanden"
    fi

    # Überprüfe und bearbeite DNS_BOGUS_PRIV
    if grep -q "^DNS_BOGUS_PRIV=false" /etc/pihole/setupVars.conf; then
        sudo bash -c "sed -i 's/^DNS_BOGUS_PRIV=false/DNS_BOGUS_PRIV=true/' /etc/pihole/setupVars.conf"
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

# solve problem when systemd-resolv is blocking port 53
# Uncomment DNS and DNSStubListener lines, change values
sudo sed -i 's/^#DNS=/DNS='"192.168.0.3"'/; s/^#DNSStubListener=yes/DNSStubListener=no/' "/etc/systemd/resolved.conf"
echo "Changes made to /etc/systemd/resolved.conf"


sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Create the systemd service file
sudo bash -c "cat << EOF > /etc/systemd/system/unbound.service
[Unit]
Description=Unbound
Wants=network.target
After=syslog.target network-online.target

[Service]
Type=simple
ExecStart=sudo unbound
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
EOF"

# Reload systemd to read the new service file
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable unbound
sudo systemctl start unbound

sudo pihole restartdns

# reboot is necessary
source "$HOME/rpi/tools/restart.sh"