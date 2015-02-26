# timecapsule #

[![Puppet Forge](https://img.shields.io/badge/puppetforge-1.1.0-blue.svg)](https://forge.puppetlabs.com/swizzley88/timecapsule)
[![Build Status](https://travis-ci.org/swizzley/swizzley88-timecapsule.svg?branch=master)](https://travis-ci.org/swizzley/swizzley88-timecapsule)

**Table of Contents**

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Presumptions](#presumptions)
    * [Credentials](#credentials)
4. [Usage](#usage)
    * [Server](#server)
    * [Client](#client)
    * [Considerations](#considerations)
5. [Troubleshooting](#troubleshooting)
    * [selinux](#selinux)
    * [Mac](#mac)
    * [Notes](#notes)
6. [Requirements](#requirements)
7. [Compatibility](#compatibility)
8. [Limitations](#limitations)
9. [Development](#development)
    * [TODO](#todo)
    
## Overview ##

This is the timecapsule module. It provides an open-source "Time Capsule" to be used for OSX automated backups via the "Time Machine".


## Module Description ##

The timecapsule module turns your Redhat based system into a Time Machine server. It depends on netatalk 2.2.3 rpm which is included by in the fedora repo but not in EPEL or BASE of RHEL/CentOS. Therefore an external mirror is used to download the package (netatalk-2.2.3-9.fc20) for CentOS/RHEL systems.


## Setup ##

#### Presumptions ####

The timecapsule module requires layer 2 connectivity from your Mac to your time capsule server for announcements. Your timecapsule server will need to be able to access the web to download the required packages, and this module assumes you are not using a proxy, if you are, you will need to configure that manually.


#### Credentials ####

Even if you prefer to use another user/group than 'timecapsule', you still want to set the $password to something to use from you mac, or just use 'timecapsule'. In order to set your password hash to be managed, use the following command:
```bash
openssl passwd -crypt "secretPassword"
```


## Usage ##

#### Server ####
```ruby
include timecapsule
```

```ruby
class timecapsule::params{
$user = 'timecapsule'
$password = '5XjeYxRW0bohs' #this equals "timecapsule" 
$group = 'timecapsule'
$mount = '/mnt/timecapsule'
}
```

#### Client ####

Open up Time Machine from Settings and flip it on, you will see the hostname of your timecapsule server appear and the disk icon, select it, and voila.


#### Considerations ####

If you use a spacewalk or satellite server for package management, or just plain
don't want to enable the whole repo because you want to download and install the
requirements manually for some reason, then just disable the $use_epel in params.

```ruby
class timecapsule::params{
  $use_epel = true
}
```


## Troubleshooting ##

#### selinux ####

selinux was completely ignored, so maybe start there...
`setenfoce 0`


#### Mac ####

1. Close "settings" on your Mac and re-open it for Time Machine to rescan/listen. 
2. Open finder and you should see your server, click it. If you're logged in as a different user than $user, or the password on your mac is different than $password, then you will need to type them in once manually.
3. Open the mount in finder. You should see your $mount directory.

If you are connecting through finder, but Time Machine still doesn't find your server, then bounce the netatalk service a couple times on the server.

```bash
[root@timecapsule]# /usr/bin/systemctl stop netatalk.service
[root@timecapsule]# /usr/bin/systemctl start netatalk.service
```


#### Notes ####

Your mounts to the time capsule will drop if your Mac goes to sleep, which can cause backup failures. I reccomend a couple of things to combat this issue.

1. By installing caffeine. Linked here: https://itunes.apple.com/us/app/caffeine/id411246225?mt=12#
2. Ensure $mount is not a symlink, but an actual mount point with enough space to backup to, because puppet will ensure it is a directory. 
3. If you intend to use a remote mount point, I advise you add the mount parameters to init.pp first, and `ensure => mounted`


## Requirements ##

puppetlabs/stdlib >= 4.2.0 

puppetlabs/firewall >= 1.1.3 


## Compatibility ##

  * RHEL 7
  * CentOS 7
  * Fedora 20


## Limitations ##

This module has been tested on:

Server: 
  - Fedora 20
  - CentOS 7 

Client: 
  - OSX 10.10.2 (Yosemite)

This module should work on:

Server: 
  - Fedora 21
  - CentOS 7.1
  - RHEL Server 7.x
  - RHEL Client 7.x
  - RHEL Workstation 7.x 
	
Client: 
  - OSX 10.10.x (Yosemite)
  - OSX 10.9.x  (Maverics)
  - OSX 10.8.x  (Mountain Lion)
  - OSX 10.7.x  (Lion)
  - OSX 10.6.x  (Snow Leopard)
  - OSX 10.5.x  (Leopard)
	 
 
## Development ##

Any updates or contibutions are welcome.

Report any issues with current release, as any input will be considered valuable.


#### TODO ####

  * Add support for Debian operating system family
  * Add support for netatalk >= 3.0.0
  * Add selinux support
  * Add configurable options for additional apple shares
 

###### Contact ######

Email:  morgan@aspendenver.org

WWW:    www.aspendenver.org

Github: https://github.com/swizzley


