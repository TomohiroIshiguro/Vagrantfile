#!/bin/bash

# If you don't need web server in the server, could you remove this area.

sudo yum install -y httpd
sudo usermod -aG vagrant apache

sudo systemctl start httpd.service
sudo systemctl enable httpd.service