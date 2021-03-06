#!/bin/bash

######################
# BigLinux Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


export DEBIAN_FRONTEND=noninteractive

eatmydata synaptic --non-interactive --hide-main-window --update-at-startup

# Instala pacotes do arquivo install.txt e gera o arquivo apt_errors1.txt com o log de pacotes com erros

eatmydata synaptic -o Install-Recommends=0 -o APT::Install-Recommends=false --dist-upgrade-mode --set-selections < install.txt


#Tenta resolver erros de pacotes
eatmydata apt-get -f install
eatmydata dpkg --configure -a

rm -f install.txt
