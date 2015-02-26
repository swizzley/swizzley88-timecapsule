# Class: timecapsule::packages
#
# This module manages timecapsule
#

class timecapsule::packages {
  $package = ['netatalk', 'avahi', 'dbus', 'nss-mdns']
  #ip url is from rpmfind, prefer an official mirror
  #$netatalk_url = 'ftp://195.220.108.108/linux/fedora/linux/releases/20/Everything/x86_64/os/Packages/n/netatalk-2.2.3-9.fc20.x86_64.rpm'
  $netatalk_url = 'http://mirrors.maine.edu/Fedora/releases/20/Everything/x86_64/os/Packages/n/netatalk-2.2.3-9.fc20.x86_64.rpm'

}
