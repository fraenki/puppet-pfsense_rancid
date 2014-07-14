# == Class: pfsense_rancid
#
# This module prepares pfSense so that its configuration
# can be backed up with RANCID.
#
# === Examples
#
#  class { 'pfsense_rancid':
#    manage_user => false,
#    diskusage => false,
#    username => 'cfgbackup',
#    password => '$1$LIq.MKZE$oYK01CVMjxPfBEicJDE9L1',
#    authorizedkeys => [ 'ssh-rsa AAAAeeefff user1@example.com',
#                        'ssh-rsa AAAAeeefff user1@example.com' ],
#  }
#
class pfsense_rancid(
  # class
  $diskusage      = true,
  $manage_user    = true,
  # user
  $username       = 'rancid',
  $password       = undef,
  $authorizedkeys = [],
  # pfsense
  $real_group     = 'nobody',
) {

  # Input validation
  include stdlib
  validate_array($authorizedkeys)
  validate_bool($diskusage)
  validate_bool($manage_user)
  validate_string($username)
  validate_string($password)

  if $password == undef and $manage_user {
    fail("pfSense user requires a password")
  }

  case $::operatingsystem {
    'FreeBSD': { }
    default: { fail("OS $::operatingsystem is not supported") }
  }

  if ! $::pfsense {
    fail("Requires a pfSense appliance")
  }

  if $manage_user {
    pfsense_user { "$username":
      ensure => 'present',   
      password => $password,
      comment => 'rancid user',
      privileges => ['user-shell-access'],
      authorizedkeys => $authorizedkeys,
    }
  }

  $directory = "/home/${username}"

  file { "${directory}/bin":
    ensure  => directory,
    owner   => $username,
    group   => $real_group,
    mode    => '0755',
    require => Pfsense_user["$username"],
  }

  file { "${directory}/.tcshrc":
    ensure  => file,
    content => template('pfsense_rancid/tcshrc.erb'),
    owner   => $username,
    group   => $real_group,
    mode    => '0644',
    require => Pfsense_user["$username"],
  }

  file { "${directory}/bin/rancid-compat":
    ensure  => file,
    content => template('pfsense_rancid/rancid-compat.erb'),
    owner   => $username,
    group   => $real_group,
    mode    => '0755',
    require => Pfsense_user["$username"],
  }

}
