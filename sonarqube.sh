#!/bin/bash
# ============================================================
# sonarqube.sh — SonarQube Community Setup
# Target: Amazon Linux 2023
# Instance: t2.medium or higher (Min 2GB RAM required)
# Port: 9000
# ============================================================

set -e

SONAR_VERSION=25.7.0.110598

echo "== Step 1: Update system =="
dnf update -y

echo "== Step 2: Install Java 21, wget, and unzip =="
dnf install -y \
    java-21-amazon-corretto \
    wget \
    unzip

echo "== Step 3: Configure Kernel System Limits for Elasticsearch =="
# SonarQube's embedded Elasticsearch requires higher memory map limits to start
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
echo "vm.max_map_count=524288" >> /etc/sysctl.conf
echo "fs.file-max=131072" >> /etc/sysctl.conf

echo "== Step 4: Download SonarQube =="
cd /opt
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip

echo "== Step 5: Extract SonarQube =="
unzip -q sonarqube-${SONAR_VERSION}.zip

echo "== Step 6: Create sonar user =="
id sonar &>/dev/null || useradd sonar

echo "== Step 7: Set permissions =="
chown -R sonar:sonar /opt/sonarqube-${SONAR_VERSION}
chmod -R 755 /opt/sonarqube-${SONAR_VERSION}

echo
echo "============================================"
echo "Installation Complete!"
echo "============================================"
echo
echo "Next, run these commands manually to start SonarQube:"
echo
echo "sudo su - sonar"
echo "/opt/sonarqube-${SONAR_VERSION}/bin/linux-x86-64/sonar.sh start"
echo
echo "Then open:"
echo "http://<EC2-PUBLIC-IP>:9000"
echo
echo "Default Login:"
echo "Username: admin"
echo "Password: admin"
