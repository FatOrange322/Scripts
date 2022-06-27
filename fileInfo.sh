#!/bin/bash

ARGC=$#
ARGV=$@
USAGE="Usage:fileInfo [filePath]"

clear

#Function to check which terminal is being used
#Credits to https://askubuntu.com/questions/476641/how-can-i-get-the-name-of-the-current-terminal-from-command-line
which_term(){
    term=$(ps -p $(ps -p $$ -o ppid=) -o args=);
    found=0;
    case $term in
        *gnome-terminal*)
            found=1
            echo "gnome-terminal " $(dpkg -l gnome-terminal | awk '/^ii/{print $3}')
            ;;
        *lxterminal*)
            found=1
            echo "lxterminal " $(dpkg -l lxterminal | awk '/^ii/{print $3}')
            ;;
        rxvt*)
            found=1
            echo "rxvt " $(dpkg -l rxvt | awk '/^ii/{print $3}')
            ;;
        ## Try and guess for any others
        *)
            for v in '-version' '--version' '-V' '-v'
            do
                $term "$v" &>/dev/null && eval $term $v && found=1 && break
            done
            ;;
    esac
    ## If none of the version arguments worked, try and get the 
    ## package version
    [ $found -eq 0 ] && echo "$term " $(dpkg -l $term | awk '/^ii/{print $3}')    
}

#Execute command based on which terminal is being used
executeTerminalCommand() {
	if [[ $1 == *"zsh"* ]]; then
		gnome-terminal --title="$3" -e "sh -c '$2; read response'" &> /dev/null;
	else 
		echo $1
	fi
}

#Binwalk Function
executeBinwalk () {
    if ! command -v binwalk &> /dev/null;then
		echo "Binwalk could not be found..."
		echo "Try installing it"
		exit
	else
		term="$(which_term)"
		executeTerminalCommand "$term" "binwalk $1" "Binwalk"
	fi
}

#Foremost Function
executeForemost () {
    if ! command -v foremost &> /dev/null;then
		echo "Foremost could not be found..."
		echo "Try installing it"
		exit
	else
		term="$(which_term)"
		executeTerminalCommand "$term" "foremost -i $1" "Foremost"
	fi
}

#ExifTool Function
executeExifTool () {
    if ! command -v exiftool &> /dev/null;then
		echo "Exiftool could not be found..."
		echo "Try installing it"
		exit
	else
		term="$(which_term)"
		executeTerminalCommand "$term" "exiftool $1" "Exiftool"
	fi
}

#HexEditor Function
executeGhex() {
    if ! command -v ghex &> /dev/null;then
		echo "Ghex could not be found..."
		echo "Try installing it"
		exit
	else
		term="$(which_term)"
		executeTerminalCommand "$term" "ghex $1" "Ghex"
	fi
}

#Check for arguments
if [ $ARGC = 1 ]; then
	#Check if argument is valid path
	if [ -e $ARGV ]; then
		executeBinwalk "$ARGV"
		executeForemost "$ARGV"
		executeExifTool "$ARGV"
		executeGhex "$ARGV"
	else
	    echo "invalid path"
fi
else
	echo $USAGE
fi