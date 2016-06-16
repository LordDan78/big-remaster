#!/bin/bash

######################
# Kaiana Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


# Forma de uso
# $1 pasta de trabalho
# $2 tipo de compactacao xz ou gzip
# $3 nome de identificacao do iso
# Exemplo: sudo /usr/share/kaiana/iso-generator/makesquashfs.sh "/home/bruno/remaster/iso32bits" "gzip" "Kaiana 14.04 final"


cd "$1"

# Kernel e initrd para o livecd
mkdir -p image/casper
rm -f remaster/chroot/boot/*old-dkms*

cp -f $(find remaster/chroot/boot/ -name vmlinuz* |  tail -1) image/casper/vmlinuz
cp -f $(find remaster/chroot/boot/ -name initrd.img* |  tail -1) image/casper/initrd.lz

# Gera o manifest
chroot remaster/chroot dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee image/casper/filesystem.manifest
cp -v image/casper/filesystem.manifest image/casper/filesystem.manifest-desktop
REMOVE='ubiquity kaiana-install-desktop-icon ubiquity-frontend-gtk ubiquity-frontend-kde casper lupin-casper live-initramfs user-setup discover1 xresprobe os-prober libdebian-installer4'
for i in $REMOVE 
do
        sed -i "/${i}/d" image/casper/filesystem.manifest-desktop
done

# Gera o squashfs
#gzip
if [ "$2" = "gzip" ]; then
    rm -f remaster/chroot/apt_errors*.txt
    rm -f image/casper/filesystem.squashfs
    mksquashfs remaster/chroot image/casper/filesystem.squashfs
fi


#xz
if [ "$2" = "xz" ]; then
    rm -f remaster/chroot/apt_errors*.txt
    rm -f image/casper/filesystem.squashfs
    mksquashfs remaster/chroot image/casper/filesystem.squashfs -comp xz -Xbcj x86 -no-xattrs -always-use-fragments -b 16384  -Xdict-size 100%
fi


printf $(du -sx --block-size=1 remaster/chroot | cut -f1) > image/casper/filesystem.size


touch image/ubuntu
mkdir image/.disk
cd image/.disk
touch base_installable
echo "full_cd/single" > cd_type
echo "$3" > info
echo "Remaster generated by Kaiana Iso Generator - http//www.uniaolivre.com" > release_notes_url
cd ../../