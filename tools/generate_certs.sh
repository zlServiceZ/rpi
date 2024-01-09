#!/bin/bash

sudo openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/certs/key.pem -out /etc/ssl/certs/cert.pem -days 365 -nodes
