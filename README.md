## Description

Installs and configures a Zenoss server with the `zenoss::server` recipe.

LWRPs are available for installing ZenPacks, zenpatches, loading devices and 
users and running zendmd commands.

## Requirements
Core 4 is not available in a 32 bit distribution. You will need to ensure you
are running on a 64 bit machine

## Important Information
**CAUTION**. Version 2.0.0 of this cookbook represents a large number of changes.
Please refer to the change log of a list of breaking changes. You **should not**
run 2.0.0 of this cookbook against an existing Zenoss installation without
careful planning, and lots of **TESTING, TESTING AND MORE TESTING**

Core 4 is now the default version that will be installed. If are currently using
an older version of this cookbook to manage a Core 3 installation please refer
to the upgrading section below.

Core 4 introduces **alot** of new dependencies. In an attempt to keep all Zenoss
clients from needing to carrying the burden of all these dependencies the
`zenoss::client` recipe code has been moved to a a new dedicated [zenoss_client cookbook](http://community.opscode.com/cookbooks/zenoss_client)
cookbook. In an attempt to reduce the impact the `zenoss::client` recipe still
exists however it is simpler a wrapper that will call `zenoss_client::default`

Attempts were made to preserve the Core 3 code base with as few alterations as
possible. Very few changes were made to any of the supporting LWRPs. The goal
is that with a few run_list changes existing users should be able to continue
managing their 3.x installations, however it will require care, planning, and 
testing. Please refer to the section on upgrading below.

## Upgrading
Every upgrade scenario is unique in it is own way so your mileage may vary, and
you should test your upgrade on a pre-production configuration first.

If you intend to continue to manage your existing Core 3 installation using
this new version, you should take the following steps:

* Set `node['zenoss']['server']['version']` to "3.2.1-0" using a normal or
  override level. **Don't** set it in any of the *default* levels
* The server recipe now contains a small bit of new logic to dispatch execution
  to the proper version specific recipe. This should continue to be backward 
  compatible however if you'd like to steer clear of this logic, you can replace
  `zenoss::server` with `zenoss::server3` in your node's run_list.


## Roles
The example roles in the `zenoss/roles` directory should be loaded for use, 
refer to the Roles subsection.

## Support Matrix
With the release of Core 4 came a reduction in the number of support platforms
that Zenoss will on. As its made available on other platforms this cookbook
will hopefully keep up. To make things a little easier the following table
should help to Identify what versions are supported on which platforms

|                       |Core 4|Core 3|
|-------------------|---------|----------|
|Ubuntu 10.04    |         | X       |
|RHEL/Centos 5 | X      | X       |
|RHEL/Centos 6 | X      |          |


## Attributes
Attributes are under the `zenoss` namespace. The number of attributes are 
starting to grow, so they are getting sub divided and in some cases getting
put into a separate file where it makes sense. The attribute files themselves
are self documented and rather than try and keep a large amount of attribute 
documentation in sync, please refer directly to the attribute files.

Attributes that independent of the Zenoss version are in the default.rb file.
Attributes that are specific to Core 4 are stored are in the core4.rb file


## Resources/Providers

### zenbatchload
This LWRP builds a list of devices, their Device Classes, Systems, Groups, 
Locations and their properties and populates the `zenoss::server` with them.

### zendmd
This LWRP takes a command to be executed by the `zendmd` command on the Zenoss 
server. Examples include setting passwords and other changes to the Zope object 
database.

### zenpack
Installs ZenPacks on the `zenoss::server` for use for extending the base 
functionality.

### zenpatch
Installs patches on the `zenoss::server` based on the number referenced in 
the ticket.

## Recipes

### Default (default.rb)
The default recipe is essentially unused, but it is intended to handle setting
up things that might be required to leverage the LWRPs this cookbook provide.
If you are not using this cookbook to manage a server installation, then you
should add this cookbook to your nodes run_list to ensure in future versions
you'll continue be able to leverage the LWRPs.

### Client (client.rb)
Usage of this recipe is deprecated. The recipe exists for backward compatibility.
You should replace references to this recipe with `zenoss_client::default`

### Server (server.rb)
The server recipe should be considered your main entry point into this
cookbook. It will make some decisions based on your configuration and dispatch
execution to the necessary recipes in the cookbook. For the most part the rest
of the recipes in this cookbook shouldn't get added directly to your node's
run_list unless you have a very compelling reason to do so.

## Configure Admin User (configure_admin_user.rb)
This recipe is used to set some meta data around your admin user. 

*Warning*: This recipe is currently not idempotent due to its usage of the 
`zenoss_zendmd` resource. A future release to aim to make this idempotent.

## Configure SMTP Settings (configure_smtp_settings.rb)
This recipe is used to configure SMTP settings in your Zenoss server installation
allowing your Zenoss server to send email notifications.

*Warning*: This recipe is currently not idempotent due to its usage of the 
`zenoss_zendmd` resource. A future release to aim to make this idempotent.

## Core 4 (core4.rb)
This is the work horse recipe for installing Core 4 on a node. This recipe
is automatically invoked when you request a Zenoss version of 4.x be installed

## Core 4 Performance Tweaks (core4_performance_tweaks.rb)
*NOT USED*. This recipe is currently not used, but exists to express intent.
The current code inside relies on some direct file edit nastiness. Future
versions of this cookbook intend to make this a usable and idempotent recipe

## Java (java.rb)
This recipe wraps the `java::default` recipe. It will setup some node attributes
used by the Java cookbook and then call it.

## MySQL 5.5 (mysql55.rb)
At the time of this writing the community MySQL cookbook didn't handle
installing MySQL 5.5 on RHEL. This recipe will ensure a version of MySQL gets
installed that is compatible with Zenoss Core 4.

## Post Installation (post_install.rb)
This recipe will run any post installation tasks that will make installing
Zenoss Core 4 a little easier. Right now this simply sets a flag so you
can skip the new setup wizard the first time you access the Zenoss UI.

## Redis (redis.rb)
With the release of 4.2.4 Zenoss Core now requires Redis. This recipe performs
a simple check to determine what version you are installing and if its needed
Redis will be installed via the redisio cookbook.

## RRD Tool (rrdtool.rb)
Zenoss is pretty particular around the version of RRD Tool that it needs. This
recipe ensures you get the exact version that Zenoss wants to have.

## Server 3 (server3.rb)
This is for the most part the unaltered code of the server recipe before this
cookbook was updated to support Core 4. The server recipe will call this recipe
if you have requested a 3.x installation.

## SSH Key Configuration (ssh_key_config.rb)
This recipe will handle setting up an SSH Key pair for your Zenoss server.


## Data Bags
Create a `users` data bag that will contain the users that will be able to log 
into the Zenoss server (members of the 'sysadmin' group). The admin user is 
automatically provided. Zenoss-specific information is stored in the `zenoss` 
hash. Passwords may be set or left out. Multiple roles may be set; the choices 
with Zenoss Core are Manager, ZenManager, ZenUser or empty. Users may belong 
to User Groups within Zenoss (listing them here will create them). Example user 
data bag item:

    {
    "id": "zenossadmin",
    "groups": "sysadmin",
    "zenoss": {
      "password": "abc",
      "roles": ["Manager", "ZenUser"],
      "user_groups": ["managers"],
      "pager": "zpager@example.com",
      "email": "zemail@example.com"
      }
    }

Two example data bags are provided and may be loaded like this:

    knife data bag create users
    knife data bag from file users cookbooks/zenoss/data_bags/Zenoss_User.json
    knife data bag from file users cookbooks/zenoss/data_bags/Zenoss_Readonly_User.json

## Roles

This cookbook provides a number of example roles for mapping attributes to Zenoss 
Device Classes, Groups and Locations. There is also a role called "ZenossServer" 
that may be used to configure the Zenoss server for convenience. These roles may 
be loaded like this:

    knife role from file cookbooks/zenoss/roles/Class_Server-SSH-Linux.rb

### Device Class Roles
* Roles intended to map to Device Classes set the attribute `[:zenoss][:device][:device_class]`. This is an override_attribute on the role.
* Roles may set default attributes for `[:zenoss][:device][:modeler_plugins]`, `[:zenoss][:device][:templates]` and `[:zenoss][:device][:properties]` to be applied to the Device Class.
* The `name` for the role is unused by Zenoss.
* Nodes may only belong to a single Device Class, nodes that belong to multiple Device Class roles will have non-determinant membership in a single Device Class.

### Location Roles
* Roles intended to map to Locations set the attribute `[:zenoss][:device][:location]`. This is an override_attribute on the role.
* Location roles may set the have `[:zenoss][:device][:address]` attribute for the Google map address. If you are using a newline, make sure it is entered as `\\n` in the role. This is an override_attribute on the role.
* The `name` and the `description` for the role map to the name and description of the Location.
* Nodes may only belong to a single Location, nodes that belong to multiple Location roles will have non-determinant membership in a single Location.

### Group Roles
* The roles in organization will populate the Groups on the Zenoss server.
* The Device Class and Location roles will not be added to Groups.

## Usage
**IMPORTANT** Zenoss relies on Oracle's Flavor of Java. This requires you
to accept the license agreement but setting a value of `true` for the node
attribute `['java']['oracle']['accept_oracle_download_terms']`. You can read
a bit more about this in the details of the [Java cookbook](http://community.opscode.com/cookbooks/java)

For a Zenoss server add the following recipe to the run_list:

    recipe[zenoss::server]

This will allow device nodes to search for the server by this role. Devices are currently added by their external IP addresses, which is effective in hybrid clouds but you may want to modify this for environments in a single platform (ie. EC2-only). Check the `providers/zenbatchload.rb` for this setting. Running `chef-client --log_level debug` on the server node will show the calls for zendmd and zenbatchload commands.

To register a device for monitoring with Zenoss on a client node:

    include_recipe "zenoss::client"

Any Properties that need to be set are exposed as attributes on the node and 
the Roles used by this cookbook.

Zenoss has the concept of Devices, which belong to a single Device Class and 
Location. Chef nodes implementing the `zenoss::client` recipe become Zenoss 
Devices and the Device Class and Location roles may be used for placing in the 
proper organizers. Zenoss also has Groups and Systems which are essentially 
ways of tagging and organizing devices (and devices may belong to multiple 
Groups and Systems). Searches for nodes that belong to other roles will 
populate the Groups. Searches for nodes applying recipes are used to populate 
the Systems.

If you are monitoring devices running on Amazon's EC2 with Zenoss, you will 
need to allow ICMP ping from your Zenoss server.

Because of limitations in zenbatchload, changing settings after initial 
configuration may not persist. This will be revisited with the upcoming 
Zenoss 4.x release (COO-895).

## License and Author
Author:: Matt Ray <matt@opscode.com>  
Author:: David Petzel <davidpetzel@gmail.com> 

Copyright:: 2010, Zenoss, Inc  
Copyright:: 2010, 2011 Opscode, Inc  

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
