#!/bin/bash

# Check for script deps
target=/usr/bin
declare -a deps=(
  [0]=$target/lsb_release
  [1]=$target/printf
)
for i in ${!deps[@]}; do
  if [[ ! -f ${deps[i]} ]]; then
    echo "Could not find ${deps[i]}..."
    exit
  fi
done

# Get Linux dist
OS=$(lsb_release -a | grep -i "distributor id" | cut -d ":" -f 2 | sed "s|\t||g")

# Fallback to $AS if doas is not installed
if [[ ! -f $target/doas ]]; then
  AS=sudo
else
  AS=doas
fi

# Gentoo install
gentoo_install() {
  if [[ ! -f $target/flatpak ]]; then
    $AS emerge -q flatpak
  else
    printf "flatpak is already installed...\n"
  fi
  if [[ ! -f $target/flatpak-builder ]]; then
    $AS emerge -q flatpak-builder
  else
    printf "flatpak-builder is already installed...\n"
  fi
}

# Arch install
arch_install() {
  if [[ ! -f $target/flatpak ]]; then
    $AS pacman -S flatpak --noconfirm
  else
    printf "flatpak is already installed...\n"
  fi
  if [[ ! -f $target/flatpak-builder ]]; then
    $AS pacman -S flatpak-builder --noconfirm
  else
    printf "flatpak-builder is already installed...\n"
  fi
}

# OpenSuse install
suse_install() {
  if [[ ! -f $target/flatpak ]]; then
    $AS zypper in -y flatpak 
  else
    printf "flatpak is already installed...\n"
  fi
  if [[ ! -f $target/flatpak-builder ]]; then
    $AS zypper in -y flatpak-builder
  else
    printf "flatpak-builder is already installed...\n"
  fi
}

# Ubuntu install
ubuntu_install() {
  if [[ ! -f $target/flatpak ]]; then
    $AS apt install -y flatpak
  else
    printf "flatpak is already installed...\n"
  fi
  if [[ ! -f $target/flatpak-builder ]]; then
    $AS apt install -y flatpak-builder
  else
    printf "flatpak-builder is already installed...\n"
  fi
}

# Run installer function
case $OS in 
  Gentoo) gentoo_install ;;
  Arch) arch_install ;;
  openSUSE) suse_install ;;
  Ubuntu) ubuntu_install ;;
esac
