#!/bin/bash
# ============================================================
# jenkins.sh — Automated Jenkins + Maven + Java setup
# Target: Amazon Linux 2023 (fresh EC2 instance)
# Usage:  sudo sh jenkins.sh
# ============================================================

set -e   # koi bhi command fail ho toh script turant ruk jaye (safety)

echo "==> Step 1: System update"
dnf update -y

echo "==> Step 2: Install Java 21 (Amazon Corretto)"
dnf install java-21-amazon-corretto -y

echo "==> Step 3: Add Jenkins repo + import GPG key"
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/rpm-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/rpm-stable/repodata/repomd.xml.key

echo "==> Step 4: Install Git, Jenkins, and Maven (bound directly to Corretto 21)"
# NOTE: maven-amazon-corretto21 seedha sahi Java version se bind karta hai —
# generic 'maven' install + baad mein 'dnf swap' karne wala do-step avoid ho jaata hai.
dnf install git jenkins maven-amazon-corretto21 -y

echo "==> Step 5: Enable + start Jenkins service"
systemctl enable jenkins
systemctl start jenkins

echo "==> Step 6: Verify installations"
java --version
git --version
mvn --version
systemctl status jenkins --no-pager

echo "==> Step 7: Jenkins initial admin password (for browser setup)"
echo "Jenkins UI: http://<your-ec2-public-ip>:8080"
cat /var/lib/jenkins/secrets/initialAdminPassword

echo "==> Setup complete!"
