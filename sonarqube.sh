#!binbash
# ============================================================
# sonarqube.sh — SonarQube Community Setup
# Target Amazon Linux 2023
# Instance t2.medium or higher
# Port 9000
# ============================================================

set -e

SONAR_VERSION=25.7.0.110598

echo == Step 1 Update system
dnf update -y

echo == Step 2 Install Java 21 + wget + unzip
dnf install -y 
    java-21-amazon-corretto 
    wget 
    unzip

echo == Step 3 Download SonarQube

cd opt

wget httpsbinaries.sonarsource.comDistributionsonarqubesonarqube-${SONAR_VERSION}.zip

echo == Step 4 Extract SonarQube

unzip sonarqube-${SONAR_VERSION}.zip

echo == Step 5 Create sonar user

id sonar &devnull  useradd sonar

echo == Step 6 Set permissions

chown -R sonarsonar optsonarqube-${SONAR_VERSION}
chmod -R 755 optsonarqube-${SONAR_VERSION}

echo
echo ============================================
echo Installation Complete
echo ============================================

echo
echo Next run these commands manually
echo

echo sudo su - sonar

echo optsonarqube-${SONAR_VERSION}binlinux-x86-64sonar.sh start

echo

echo Then open
echo httpEC2-PUBLIC-IP9000

echo

echo Default Login
echo Username  admin
echo Password  admin