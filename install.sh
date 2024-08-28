#!/bin/bash

# Check and install python-nautilus based on package manager
if type "pacman" > /dev/null 2>&1
then
    pacman -Qi python-nautilus &> /dev/null
    if [ `echo $?` -eq 1 ]
    then
        sudo pacman -S --noconfirm python-nautilus
    fi
elif type "apt-get" > /dev/null 2>&1
then
    package_name="python-nautilus"
    if [ -z `apt-cache search --names-only $package_name` ]
    then
        package_name="python3-nautilus"
    fi
    
    installed=`apt list --installed $package_name -qq 2> /dev/null`
    if [ -z "$installed" ]
    then
        sudo apt-get install -y $package_name
    fi
elif type "dnf" > /dev/null 2>&1
then
    installed=`dnf list --installed nautilus-python 2> /dev/null`
    if [ -z "$installed" ]
    then
        sudo dnf install -y nautilus-python
    fi
else
    echo "Failed to find python-nautilus, please install it manually."
fi

# Create directory for Nautilus extensions
mkdir -p ~/.local/share/nautilus-python/extensions

# Remove existing file if it exists
rm -f ~/.local/share/nautilus-python/extensions/alacritty-nautilus.py

# Copy the local file to the Nautilus extensions directory
cp /home/jaime/Documents/Nautilus-Kitty/kaspian-kitty-nautilus/kitty-nautilus.py ~/.local/share/nautilus-python/extensions/kitty-nautilus.py

# Restart Nautilus to apply changes
nautilus -q

echo "Installation finished"

