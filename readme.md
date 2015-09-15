Before running the setup script, make sure to install grub-pc-bin since it is used to install the bootloader

# Creating the rootfs for X86_64

sudo mount -o rbind /sys ./sys
sudo mount -o rbind /dev ./dev
sudo mount -o rbind /proc ./proc
sudo cp /etc/resolv.conf etc/resolv.conf
sudo chroot . /bin/bash


apt-get update
apt-get install ssh python linux-image-extra-3.19.0-23-generic linux-image-3.19.0-23-generic avahi-daemon avahi-utils vim

vi /var/lib/dpkg/info/libpam-systemd\:amd64.postinst: comment start
vi /var/lib/dpkg/info/libpam-systemd\:amd64.prerm: comment stop
apt-get install -f
vi /var/lib/dpkg/info/libpam-systemd\:amd64.postinst: uncomment start
vi /var/lib/dpkg/info/libpam-systemd\:amd64.prerm: uncomment stop

useradd -r -m -g root bb
passwd bb
su - bb
ssh-keygen
cp .ssh/id_rsa.pub .ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
<CTRL-D>


visudo:
bb ALL=(ALL) NOPASSWD:ALL

<CTRL-D>

sudo umount -l ./dev
sudo umount -l ./sys
sudo umount -l ./proc
cd ..
sudo tar --numeric-owner -C x86_64 -cz -f ~/bigboards-core-14.04.2-core-amd64.tar.gz .

I ran into this one while building a custom LiveCD. My work-around was to comment out the daemon start and stop in /var/lib/dpkg/info/libpam-systemd\:amd64.postinst and /var/lib/dpkg/info/libpam-systemd\:amd64.prerm. I then ran apt-get -f install and then uncommented the lines. This allowed me to build the CD but it still issues an error message on the CD until I do apt-get --reinstall install libpam-systemd.