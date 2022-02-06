# AUTHOR: AIRGOLD3#7008 & https://github.com/Airgold3
#!/bin/bash

    #COLORS
    Color_Off='\033[0m'       # Text Reset

    # REGULAR COLORS
    Red='\033[0;31m'          # Red
    Green='\033[0;32m'        # Green
    Yellow='\033[0;33m'       # Yellow
    Purple='\033[0;35m'       # Purple
    Cyan='\033[0;36m'         # Cyan

    domain="candado-verde.tk";
    email="airgold3yt@gmail.com";

    if [ $(id -u) = 0 ]; then
        echo -e "$Green    
        █╗      █████╗ ███╗   ███╗██████╗ 
        █║     ██╔══██╗████╗ ████║██╔══██╗
        █║     ███████║██╔████╔██║██████╔╝
        █║     ██╔══██║██║╚██╔╝██║██╔═══╝ 
        ██████╗██║  ██║██║ ╚═╝ ██║██║     
        ══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝"

        echo -e "$Cyan\n Update packages and Upgrade system... $Color_Off"
            apt update -y && apt upgrade -y

        echo -e "$Cyan\n Installing database... $Color_Off"
            apt-get install apache2 -y
            apt install mysql-server -y
            apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y 
            apt install libapache2-mod-php -y
            a2enmod php7.4
            systemctl restart apache2
            echo -e "$Yellow\n Tell me the USER for the phpmyadmin: $Color_Off"
            read user 
            echo -e "$Yellow\n Tell me the PASSWORD for the phpmyadmin: $Color_Off"
            read -s pwd
            mysql -u root -p$pwd mysql -e "CREATE USER '$user'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$pwd'; GRANT ALL PRIVILEGES ON * . * TO '$user'@'localhost' WITH GRANT OPTION;"
        
        echo -e "$Cyan\n Activating Firewall... $Color_Off"
            echo "y" | sudo ufw enable
            ufw allow http # PORT 80
            ufw allow https # PORT 443
            ufw allow ssh # PORT 22
            ufw allow mysql # PORT 3306
            mkdir /var/www/$domain
            echo "<h1>Ubuntu 20.04 WITH SSL</h1>" > /var/www/$domain/index.html
            chown -R www-data:www-data /var/www/$domain
            chmod -R 755 /var/www/$domain
            echo "<VirtualHost *:80>
    ServerAdmin $email
    ServerName $domain
    ServerAlias www.$domain
    DocumentRoot /var/www/$domain
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/$domain.conf
            a2ensite $domain.conf
            systemctl restart apache2
            add-apt-repository ppa:certbot/certbot
            apt install -y certbot python3-certbot-apache
            certbot --apache -d $domain -d www.$domain
            systemctl restart apache2
        
        else
        echo -e "$Red\n [ERROR] I am not a root! Please open the file with $Yellow'sudo' $Color_Off \n"
        exit 1

    fi                                             
                                               
                                               
