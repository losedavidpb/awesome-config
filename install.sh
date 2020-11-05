#!/usr/bin/bash
#
# @author losedavidpb
#

_install_gtk_widgets () {
	cp -f .gtkrc-2.0 ~
	
	local NAME_ICON=McMojave-circle
	local NAME_SELECTED_ICON=McMojave-circle-dark
	local URL_ICON=https://github.com/vinceliuice/McMojave-circle
	local NAME_CURSOR=capitaine-cursors

	# Icon setup
	git clone $URL_ICON;  $NAME_ICON/install.sh; rm -fR $NAME_ICON
	gsettings set org.gnome.desktop.interface icon-theme $NAME_SELECTED_ICON
	rm -rf $NAME_ICON

	# Cursor Icon theme setup
	mkdir -p ~/.icons/default
	rm -fR ~/.icons/default/cursors
	
	cp index.theme ~/.icons/default
	ln -s /usr/share/icons/$NAME_CURSOR/cursors ~/.icons/default/cursors
}

_install_awesome_widgets () {
	while IFS= read -r line; do
		local path=$(echo $line | cut -d ":" -f 1)
		local name=$(echo $line | cut -d ":" -f 2)
		local url=$(echo $line | cut -d ":" -f 3)
		
		if [[ $(find ~/$path -name $name) != $path/$name ]]; then	
			rm -rf ~/$path/$name
			git clone https:$url
			mv $name ~/$path
		fi
	done < widgets.list

	# Special case for volume widget
	rm -rf ~/.config/awesome/volumearc
	mv ~/.config/awesome/awesome-wm-widgets/volumearc-widget ~/.config/awesome/volumearc
	rm -rf ~/.config/awesome/awesome-wm-widgets
}

_mv_awesome_themes () {
	mkdir -p ~/.config/awesome/themes
	
	rm -rf ~/.config/awesome/themes/dark-purple-23
	cp -r dark-purple-23/ ~/.config/awesome/themes/dark-purple-23
	cp -f autorun.sh ~/.config/awesome/
	cp -f rc.lua ~/.config/awesome/
}

clear
sudo ls /root &>/dev/null
clear

echo -e "\033[1;33m>>\e[m \033[1;34m SETUP FOR \033[4;36mAWESOME\e[m\e[m \033[1;33m<<\e[m"
echo -e "\033[1;34m==============================\e[m"

echo ">> Installing all the awesome widgets ..."
_install_awesome_widgets &>/dev/null

echo ">> Installing all the gtk widgets ..."
_install_gtk_widgets &>/dev/null

echo ">> Moving all the available files ..."
_mv_awesome_themes &>/dev/null

echo "Finishing the installation ..."
sleep 2
