
## v2.0.0

### Breaking Changes

- The functionality of the `zenoss::client` has been moved out to
  a new dedicated [zenoss_client cookbook](http://community.opscode.com/cookbooks/zenoss_client)
  
- Default installation version has been increased to Core 4

- The hash value for `node['zenoss']['server']['installed_zenpacks']`
  has been cleared. The ZenPacks that were previously set here
  have equivalent ZenPacks now included by default. For those that need an easy
  reference the previous value was:

        "ZenPacks.zenoss.DeviceSearch" => "1.0.0",
        "ZenPacks.zenoss.LinuxMonitor"  => "1.1.5",
        "ZenPacks.community.MySQLSSH"  => "0.4",

- The inclusion of the SNMP cookbook is no longer included by this cookbook.
  While using Zenoss to poll SNMP is a **very** common setup, enforcing its 
  inclusion would alienate users who might to use direct SSH instead of SNMP.
  
### Enhancements

- Updates were made that should help reduce or eliminate the
  requirements on using search. Previous versions had a few
  hard coded requirements. Now the cookbook will attempt to 
  apply some sane actions when search is not available
  
- Managing Core 4 installations is now supported

## v1.1.0

- [#1](https://github.com/ZCA/zenoss-chef-cookbook/issues/1) -
  Fix `ImmutableAttributeModification` error on Chef 11
- [#6](https://github.com/ZCA/zenoss-chef-cookbook/issues/6) -
  Adding Test Kitchen Support
- [#7](https://github.com/ZCA/zenoss-chef-cookbook/issues/7) -
  Enabling Caching of ZenPack listing to speed up runs
- [#8](https://github.com/ZCA/zenoss-chef-cookbook/issues/8) -
  Update maintainer information to reflect move away from Opscode

## v1.0.0
- Locking in a version to handle the transition of the previously 
  "opscode managed" code base, to the now community maintained code base.
  This version is a snapshot of the code at the time of the transition. There
  have not been any coded changes between 0.7.6 and 1.0.0

## v0.7.6:

### Improvement

- Tidy up / reformat CHANGELOG.md
  See backlog in COOK-3057

### Bug

- [COOK-2985]: zenoss cookbook has foodcritic failures

## v0.7.4:

- added wget and patch for zenpatch provider per COOK-770
- assign device class zProperties, modeling plugins and templates
  properly per COOK-887

## v0.7.2:

- add support for Zenoss 3.2.1

## v0.7.0:

- yum cookbook dependency
- CentOS 5.6 and Scientific Linux 5.5 support via yum_repository LWRP

## v0.6.2:

- add support for Zenoss 3.1.0

## v0.6.0:

- check search in client.rb to negate use of [0]
- in metadata.rb, you should add recipes http://wiki.opscode.com/display/chef/Metadata#Metadata-recipe
- move restart to server.rb for zenpack installation
- skips new install wizard
- create a random admin password (in mysql cookbook)
- user `manage_home` true
- document use of external IP addresses
- include the search zenpack
- zendmd use debug for commands
- `load_current_resource` for zenpack installation
- zenoss::client server move self to /Server/SSH/Linux instead of /Server/Linux
- monitoring server should have a default role ('monitoring' is used in Nagios)
- document enabling ping through the security group in EC2
- add additional users via zendmd (extend zendmd LWRP for user-management)
- use the "sysadmins" data bag to populate the users
- provide example `data_bag` files for loading users

## v0.5.0:

- LWRP for 3.0.3 zenpatches (http://dev.zenoss.com/trac/report/6 is the basis)
- Roles will be used for Device Classes, Groups and Locations
- Recipes will be used for Systems
- server will insert devices
- devices get added to zenoss::server that implement the zenoss::client recipe
- zenoss::clients will have attributes for any particular properties they need set

## v0.4.0:

- checks for already installed zenpacks, apt repos
- hash of `installed_zenpacks` as key->package, value->version: server attribute
- single attributes/default.rb file since there's no differentiation
- zenoss::server generate SSH keys for the zenoss user and writes it to an attribute
- zenoss::client get the SSH keys via the attribute writes it to `/home/zenoss/.ssh/authorized_keys`

## v0.3.0:

- $ZENHOME is an attribute
- `zenoss_zenpack` LWRP with :install :remove
- install linux monitor ZenPack
- `zenoss_zendmd` LWRP with :run
- sets the admin password via attribute

## v0.2.0:

- zenoss::server installs itself via apt

## v0.1.0:

- mostly documentation
- zenoss::client depends on openssh
