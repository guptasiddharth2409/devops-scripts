sudo -i

echo "Installing Java and downloading Tomcat..."
dnf update -y
dnf install -y java-21-amazon-corretto wget
useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.tar.gz -P /tmp

echo "Extracting and setting permissions..."
mkdir -p /opt/tomcat
tar -xzf /tmp/apache-tomcat-9.0.98.tar.gz -C /opt/tomcat --strip-components=1
chown -R tomcat:tomcat /opt/tomcat
chmod +x /opt/tomcat/bin/*.sh

echo "Configuring Security (Fixing 401 and 403 errors)..."
cat << 'EOF' > /opt/tomcat/conf/tomcat-users.xml
<tomcat-users>
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager"/>
  <user username="tomcat" password="siddharth2409" roles="manager-gui,manager-script,manager"/>
</tomcat-users>
EOF

cat << 'EOF' > /opt/tomcat/webapps/manager/META-INF/context.xml
<Context antiResourceLocking="false" privileged="true" >
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor" sameSiteCookies="strict" />
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
EOF

echo "Creating and starting the Tomcat service..."
cat << 'EOF' > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat 9
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto.x86_64"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now tomcat
echo "Tomcat is successfully running!"