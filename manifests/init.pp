# Class: timecapsule
#
# This module manages timecapsule, it is designed to turn a rhel like OS into
# a fully functional Mac OSX Time Capsule to be used with the built in backup
# application "Time Machine" and it relies on the netatalk package for POSIX
# translation of afp, (Apple File Protocol) along with avahi and mdns for easy
# always on configuration. It is tested and functional on CentOS7 & Fedora 20
# using the latest Mac OSX Yosemite build 10.10.2 and is free to distribute.
#
# License: Apache-2.0 License
#
# Author: Dustin Morgan <morgan@aspendenver.org>
#
# @example include timecapsule
# @param user
# @param pass
# @param group
# @param mount
#

class timecapsule (
  $repo         = $::timecapsule::params::epel,
  $user         = $::timecapsule::params::user,
  $pass         = $::timecapsule::params::password,
  $group        = $::timecapsule::params::group,
  $mount        = $::timecapsule::params::mount,
  $package      = $::timecapsule::params::package,
  $ports        = $::timecapsule::params::ports,
  $services     = $::timecapsule::params::services,
  $avahi_ssh    = $::timecapsule::params::avahi_ssh,
  $install_epel = $::timecapsule::params::use_epel,
  $gpgcheck     = $::timecapsule::params::epel_gpgcheck,
  $firewall     = $::timecapsule::params::use_iptables,
  $bonjour_ssh  = $::timecapsule::params::enable_avahi_ssh,
  $manage_user  = $::timecapsule::params::manage_user,
  $manage_group = $::timecapsule::params::manage_group,
  $afpd         = $::timecapsule::params::afpd,
  $netatalk_url = $::timecapsule::params::netatalk_url) inherits timecapsule::params {
  validate_bool($install_epel)
  validate_bool($firewall)
  validate_bool($bonjour_ssh)
  validate_bool($manage_user)
  validate_bool($manage_group)
  validate_bool($gpgcheck)

  if $install_epel {
    exec { 'install EPEL 7 repo':
      path    => '/usr/bin',
      command => "yum install -y ${repo}",
      unless  => 'test -f /etc/yum.repos.d/epel.repo',
    }

    yumrepo { 'epel':
      descr          => 'Extra Packages for Enterprise Linux 7 - x86_64',
      mirrorlist     => 'https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=x86_64',
      baseurl        => 'http://download.fedoraproject.org/pub/epel/7/x86_64',
      failovermethod => 'priority',
      enabled        => true,
      gpgcheck       => $gpgcheck,
      gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7',
    }

    file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/timecapsule/RPM-GPG-KEY-EPEL-7',
    }
  }

  if $::operatingsystem != 'Fedora' {
    exec { 'get netatalk package from rpmfind ftp':
      path    => '/usr/bin',
      command => "yum install -y ${netatalk_url}",
      unless  => 'test -f /usr/sbin/afpd',
    }
  }

  package { $package: ensure => installed } ->
  service { $services:
    ensure => 'running',
    enable => true,
  }

  file { $mount:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  file { '/etc/netatalk/afpd.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $afpd,
    require => Package['netatalk'],
    notify  => Service['netatalk'],
  }

  file { '/etc/netatalk/AppleVolumes.default':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('timecapsule/AppleVolumes.default.erb'),
    require => Package['netatalk'],
    notify  => Service['netatalk'],
  }

  file { '/etc/avahi/services/afpd.service':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('timecapsule/afpd.service.erb'),
    require => Package['avahi'],
    notify  => Service['avahi-daemon'],
  }

  exec { 'nsswitch switch':
    path    => '/usr/bin',
    command => 'cp /etc/nsswitch.conf /etc/nsswitch.conf.pre-timecapsule && sed -i "/^hosts:/c\hosts:      files mdns4_minimal dns mdns mdns4" /etc/nsswitch.conf',
    unless  => 'test -f /etc/nsswitch.conf.pre-timecapsule',
  }

  if $bonjour_ssh {
    file { $avahi_ssh:
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
  } else {
    file { $avahi_ssh: ensure => absent, }
  }

  if $firewall {
    firewall { '000 accept all timecapsule':
      port   => $ports,
      proto  => ['tcp', 'udp'],
      action => 'accept',
    }
  }

  if $manage_user {
    user { $user:
      ensure   => present,
      gid      => $group,
      password => $pass,
    }
  }

  if $manage_group {
    group { $group: ensure => present, }
  }

}