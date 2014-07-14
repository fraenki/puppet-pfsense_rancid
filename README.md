#pfsense_rancid

##Table of Contents

- [Overview](#overview)
- [Module Description](#module-description)
- [Requirements](#requirements)
  - [Dependencies](#dependencies)
- [Usage](#usage)
  - [Simple example](#simple-example)
  - [Full example](#full-example)
- [Reference](#reference)
  - [How it works](#how-it-works)
- [Acknowledgement](#acknowledgement)
- [Development](#development)

##Overview

This module will create the required user and files to backup the pfSense configuration with RANCID.

NOTE: This is NOT related to the pfSense project in any way. Do NOT ask the pfSense developers for support.

##Module Description

Backing up the pfSense configuration with RANCID has been possible for years. Still, it's a pain to set it up. This tiny module should ease the pain by doing all the work for you.

##Requirements

###Dependencies

Requires the puppetlabs/stdlib and fraenki/pfsense modules. Both are required, even if you choose to disable user management.

##Usage

###Simple example

This will create the user 'rancid' and configure your pfSense firewall for RANCID:

    class { 'pfsense_rancid':
      password => '$1$dSJImFph$GvZ7.1UbuWu.Yb8etC0re.',
    }

###Full example

Of course, you may want to customize it to match your needs:

    class { 'pfsense_rancid':
      username       => 'backupuser',
      password       => '$1$dSJImFph$GvZ7.1UbuWu.Yb8etC0re.',
      authorizedkeys => [
        'ssh-rsa AAAAksdjfkjsdhfkjhsdfkjhkjhkjhkj user1@example.com',
        'ssh-rsa AAAAksdjfkjsdhfkjhsdfkjhkjhkjhkj user2@example.com',
      ],
      diskusage      => false,
    }

In this example the username was changed to 'backupuser' instead of 'rancid'.
Additionally two SSH keys are specified to allow for passwordless login.
Finally the disk usage summary is excluded from the configuration dump.

If you do NOT want this module to create the user for you, try setting 'manage_user' to false to disable this feature.

##Reference

###How it works

It uses my pfsense_user provider to create a pfSense user and set the privileges accordingly. Two templates make sure the required .tcshrc and bin/rancid-compat files are being created.

##Acknowledgement

The 'rancid-compat' script was retrieved from http://people.freebsd.org/~thompsa/rancid-compat. All credit for this script go to Andrew Thompson.

##Development

Please use the github issues functionality to report any bugs or requests for new features.
Feel free to fork and submit pull requests for potential contributions.
