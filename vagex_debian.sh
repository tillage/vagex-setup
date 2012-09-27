#!/bin/bash
#功能：
#	基于debian的vagex挂机一键包
#原作者：主机控
#修改：
#  vagex插件更新为1.4
#  不再依赖googlecode仓库 http://code.google.com/p/vagex-debian/
#  修改部分代码，并加入注释
#备注：
#	尽量在screen下运行以防中途断线

ff_addr="http://download.cdn.mozilla.net/pub/mozilla.org/firefox/releases/3.6.26/linux-i686/en-US/firefox-3.6.26.tar.bz2"
flash_addr="http://fpdownload.macromedia.com/get/flashplayer/pdc/11.1.102.55/install_flash_player_11_linux.i386.tar.gz"
vagex_addr="https://addons.mozilla.org/firefox/downloads/file/168846/vagex_firefox_add_on-1.4.4-fn+an+fx+sm.xpi"
yvqm_addr="https://addons.mozilla.org/firefox/downloads/file/134971/youtube_video_quality_manager-1.2-fx.xpi"

func_vncpwd() {
	echo "-----------"
	echo "Plese input the VNC password below!"
	echo "-----------"
}


func_in_flash() {
	wget $flash_addr &&
	mkdir ~/.mozilla
	mkdir ~/.mozilla/plugins
	tar xzf install_add_on*.tar.gz
	mv libflashplayer.so ~/.mozilla/plugins
	rm install_add_on*.tar.gz
}

func_in_ff() {
	wget $ff_addr
	tar xjf firefox*.tar.bz2
	mv -r firefox ~/
	rm firefox*.tar.bz2
}

func_in_vnc() {
	aptitude -y install vnc4server &&
	func_vncpwd
	vncserver && vncserver -kill :1 &&
	mv ~/.vnc/xstartup ~/.vnc/xstartupbak &&
	mv xstartup ~/.vnc/ && chmod a+x ~/.vnc/xstartup &&

	mv vncserverd /etc/init.d && chmod a+x /etc/init.d/vncserverd &&
	if [ -f /etc/rc.local ]; then
		sed -i '/exit\ 0/d' /etc/rc.local
		cat <<- EOF >> /etc/rc.local
			/etc/init.d/vncserverd start
			exit 0
		EOF
	else
		update-rc.d vncserverd defaults
	fi

	mv vncreboot.sh /etc/cron.daily && chmod a+x /etc/cron.daily/vncreboot.sh

}

apt-get update &&

apt-get -y --force-yes install aptitude wget &&


func_in_vnc

func_in_ff

func_in_flash


wget $vagex_addr &&
wget $yvqm_addr &&

/etc/init.d/vncserverd start &&
