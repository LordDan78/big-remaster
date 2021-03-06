#!/bin/bash

######################
# BigLinux Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


export DEBIAN_FRONTEND=noninteractive

apt update

# Instala pacotes do arquivo install.txt e gera o arquivo apt_errors1.txt com o log de pacotes com erros
apt install --yes --force-yes --no-install-recommends $(sed ':a;$!N;s/\n/ /g;ta' install.txt) 2> /apt_errors1.txt

# Limpa lista de pacotes com erros para ficar apenas os nomes dos pacotes
rev /apt_errors1.txt | cut -f1 -d" " | rev > /apt_errors.txt

# Remove os pacotes da lista de pacotes a serem instalados na proxima tentativa
for i in $(cat /apt_errors.txt)
do
    sed -i "s|^$i$||g;/^$/d" /install.txt
done

#Tenta resolver erros de pacotes
apt-get -f install
dpkg --configure -a

apt update

#Tenta novamente para tentar reparar possiveis falhas
apt install --yes --force-yes --no-install-recommends $(sed ':a;$!N;s/\n/ /g;ta' install.txt) 2>> /apt_errors1.txt

rev /apt_errors1.txt | cut -f1 -d" " | rev >> /apt_errors2.txt
sort /apt_errors2.txt | uniq > /apt_errors.txt


for i in $(cat /apt_errors.txt)
do
    sed -i "s|^$i$||g;/^$/d" /install.txt
done

#Tenta resolver erros de pacotes
apt-get -f install
dpkg --configure -a

#Mais uma tentativa 
apt install --yes --force-yes --no-install-recommends $(sed ':a;$!N;s/\n/ /g;ta' install.txt)

#Tenta resolver erros de pacotes
apt -f install
dpkg --configure -a

rm -f install.txt
echo ''
echo ''
echo ''
echo ''

echo '###################################'
echo '###################################'
echo "       " $"Script concluido"
echo "     " $"Verifique acima se tudo"
echo "        " $"Ocorreu sem erros"
echo $"Feche essa janela para prosseguir!"

