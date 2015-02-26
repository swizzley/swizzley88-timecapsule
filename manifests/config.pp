# Class: timecapsule::config
#
# This module manages timecapsule
#

class timecapsule::config (
  $package = $::timecapsule::packages::package,
  $netatalk_url = $::timecapsule::packages::netatalk_url,
)inherits timecapsule::packages {
  $ports = ['548', '5354', '5353']
  $services = ['avahi-daemon', 'messagebus', 'netatalk']
  $avahi_ssh = '/etc/avahi/services/ssh.service'
  $afpd = ' - -tcp -noddp -uamlist uams_dhx_passwd.so,uams_dhx2_passwd.so'

}
