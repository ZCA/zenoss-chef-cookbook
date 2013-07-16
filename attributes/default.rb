#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: zenoss
# Attributes:: default
#
# Copyright 2010, Zenoss, Inc
# Copyright 2010, 2011 Opscode, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# TODO - Does this really belong here?
::Chef::Node.send(:include, Opscode::OpenSSL::Password)
set_unless['zenoss']['server']['admin_password'] = secure_password



# The version of Zenoss to install
default['zenoss']['server']['version']         = "4.2.4"

# The Public key. The server recipe will generate this if it doesn't
# already exist, and clients will read this value and setup authorized
# keys
default['zenoss']['server']['zenoss_pubkey']   = ""

# Should the setup wizard be skipped
default['zenoss']['server']['skip_setup_wizard'] = true

# The TCP port on which Zope will listen
default['zenoss']['server']['http_port'] = 8080 #The tcp port which zope listens on

# The location of zenhome
case node['platform']
when "ubuntu","debian"
  default['zenoss']['server']['zenhome']         = "/usr/local/zenoss/zenoss" #RPM is different
when "redhat","centos","scientific"
  default['zenoss']['server']['zenhome']         = "/opt/zenoss" #RPM is different
end

# Attributes related to the Zenoss User n the Zenoss Server
default['zenoss']['server']['zenoss_user_name'] = "zenoss"
default['zenoss']['server']['zenoss_group_name'] = "zenoss"
default['zenoss']['server']['zenoss_user_homedir'] = "/home/zenoss"

# Attributes related to the Zenoss user on clients
default['zenoss']['client']['zenoss_user_name'] = "zenoss"
default['zenoss']['client']['zenoss_user_homedir'] = "/home/zenoss"
# In some situations you may not want to have a local account created
# If you set this to false, you're on your own to ensure you have a user
# that the zenoss server can connect with
default['zenoss']['client']['create_local_zenoss_user'] = true


# A Hash of ZenPacks to install. Newer versions of Zenoss
# Come with many of the Core 4 ZenPacks already installed.
# The format of the hash should be
# { "ZenPacks.zenoss.PackName" => "1.0.0",}
default['zenoss']['server']['installed_zenpacks'] = {}

#patches from http://dev.zenoss.com/trac/report/6 marked 'closed'
#it might matter that these get ordered eventually as well
default['zenoss']['server']['zenpatches'] = {}

# SMTP/Email Configuration information
default['zenoss']['server']['smtp']['smtpHost'] = "localhost"
default['zenoss']['server']['smtp']['smtpPort'] = "25"
default['zenoss']['server']['smtp']['smtpUser'] = ""
default['zenoss']['server']['smtp']['smtpPass'] = ""
default['zenoss']['server']['smtp']['emailFrom'] = "zenoss@#{node['fqdn']}"
# Careful with this one, It needs to be True/False to match Python's booleans, not Ruby's
default['zenoss']['server']['smtp']['smtpUseTLS'] = "False"

# Performance Tweaks
default['zenoss']['server']['performance']['max_file_descriptors'] = 10240


# Attributes Related to Monitored Devices  

# The device class of a node.
default['zenoss']['device']['device_class'] = "/Discovered"

# The location in which to assign a Device
default['zenoss']['device']['location'] = ""

# A list of modeler plugins to assign to a node.
# In general its advisable to set these on a device class, and avoid
# Using this to assign them directly to a node
default['zenoss']['device']['modeler_plugins'] = []

# A set of properties to assign to a node
default['zenoss']['device']['properties'] = {}

# A set of RRD(Monitoring) Templats to apply to a node. In general
# its advised to set this at the device class instead
default['zenoss']['device']['templates'] = []
