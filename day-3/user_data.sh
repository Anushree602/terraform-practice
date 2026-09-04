#!/bin/bash
apt update -y
apt install -y nginx 
systemctl start nginx 
systemctl enable nginx 
rm -rf /usr/share/nginx/html/*
echo "<h1> Hello From $HOSTNAME </h1>" > /usr/share/nginx/html/index.html
systemctl restart nginx