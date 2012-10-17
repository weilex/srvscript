#! /bin/sh

url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

quitOnError() {
   if [ $? -gt 0 ]
   then
     echo -e "$@\t ${txtred}[ERROR]${txtrst}"
     exit 10
   else
     echo -e "$@\t${txtgreen}[OK]${txtrst}"
   fi
}

runscript() {
	chmod +x $1
	sh $1
	rm $1
}

firewall_startup() {
	wget -q $(url)/firewall/firewall-startup.sh --no-check-certificate
	quitOnError "Download firewall-startup script"
	runscript firewall-startup.sh
}

case "$1" in
shell)
	wget -q $(url)/bash/bash-update.sh --no-check-certificate
	quitOnError "Download bash-update script"
	runscript bash-update.sh
;;
vim)
	wget -q $(url)/vim/vim-update.sh --no-check-certificate
	quitOnError "Download vim-update script"
	runscript vim-update.sh
;;
apt)
	wget -q $(url)/apt/apt-update.sh --no-check-certificate
	quitOnError "Download apt-update script"
	runscript apt-update.sh
;;
crapt)
	wget -q $(url)/cron-apt/cron-apt.sh --no-check-certificate
	quitOnError "Download cron-apt script"
	runscript cron-apt.sh
;;
ntp)
	wget -q $(url)/ntp/ntp.sh --no-check-certificate
	quitOnError "Download ntp script"
	runscript ntp.sh
;;
nobody)
	wget -q $(url)/security/nobody-update.sh --no-check-certificate
	quitOnError "Download nobody-update script"
	runscript nobody-update.sh
;;
firewall)
	wget -q $(url)/firewall/firewall-config.sh --no-check-certificate
	quitOnError "Download firewall-config script"
	runscript firewall-config.sh
	echo ' '
	read -p "Do you want activate firewall on startup (y/n): " activate
	if [ $activate = "y" ]; then
		firewall_startup
	fi	
;;
fwstartup)
	firewall_startup
;;
fail)
	wget -q $(url)/security/fail2ban.sh --no-check-certificate
	quitOnError "Download fail2ban script"
	runscript fail2ban.sh
;;
rootkit)
	wget -q $(url)/security/rootkit.sh --no-check-certificate
	quitOnError "Download rootkit script"
	runscript rootkit.sh
;;
mail)
	wget -q $(url)/mail/exim-install.sh --no-check-certificate
	quitOnError "Download exim-install script"
	runscript exim-install.sh
;;
ftp)
	wget -q $(url)/ftp/vsftpd-install.sh --no-check-certificate
	quitOnError "Download nobody-update script"
	runscript vsftpd-install.sh
;;
lamp)
	wget -q $(url)/mysql/mysql-install.sh --no-check-certificate
	quitOnError "Download mysql-install script"
	runscript mysql-install.sh	

	wget -q $(url)/apache/apache-prefork.sh --no-check-certificate
	quitOnError "Download apache-prefork script"
	runscript apache-prefork.sh
;;
*)
	echo "Usage: installsrv {shell|vim|apt|crapt|nobody|firewall|fwstartup|fail|rootkit|mail|lamp|ftp}"
	exit 1
esac

exit 0