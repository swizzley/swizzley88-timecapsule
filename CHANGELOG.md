# Changelog swizzley88-timecapsule#

##2015-- - 1.0.3
- RHEL OS case select
- specs and tests added for travis-ci


##2015-02-25 - 1.0.2
- manage user/group by defaut
- user/group is "timecapsule"
- password is "timecapsule"
- epel gpg check true now default
- official fedora US .edu mirror for centos pkg


##2015-02-06 - 1.0.1 
- wrapped vars in curlys
- added exec:unless for centos netatalk download
- added yumrepo class for epel to ensure enabled, gpgcheck set to false
- install_epel now enabled by default
- changed epel-release url to https
- added default password for $user 
