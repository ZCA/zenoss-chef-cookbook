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

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

set_unless['zenoss']['server']['admin_password'] = secure_password

default['zenoss']['device']['device_class']    = "/Discovered" #overwritten by roles or on nodes
default['zenoss']['device']['location']        = "" #overwritten by roles or on nodes
default['zenoss']['device']['modeler_plugins'] = [] #overwritten by roles or on nodes
default['zenoss']['device']['properties']      = {} #overwritten by roles or on nodes
default['zenoss']['device']['templates']       = [] #overwritten by roles or on nodes
default['zenoss']['server']['version']         = "3.2.1-0"
default['zenoss']['server']['zenoss_pubkey']   = "" #gets set in the server recipe, read by clients
default['zenoss']['server']['skip_setup_wizard'] = true	#Will skip the setup wizard
default['zenoss']['server']['http_port'] = 8080 #The tcp port which zope listens on
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





#it might matter that these get ordered eventually
default['zenoss']['server']['installed_zenpacks'] = {
  "ZenPacks.zenoss.DeviceSearch" => "1.0.0",
  "ZenPacks.zenoss.LinuxMonitor"  => "1.1.5",
  "ZenPacks.community.MySQLSSH"  => "0.4",
}

#patches from http://dev.zenoss.com/trac/report/6 marked 'closed'
#it might matter that these get ordered eventually as well
default['zenoss']['server']['zenpatches'] = {

}

#SMTP/Email Configuration information
default['zenoss']['server']['smtp']['smtpHost'] = "localhost"
default['zenoss']['server']['smtp']['smtpPort'] = "25"
default['zenoss']['server']['smtp']['smtpUser'] = ""
default['zenoss']['server']['smtp']['smtpPass'] = ""
default['zenoss']['server']['smtp']['emailFrom'] = "zenoss@#{node['fqdn']}"
# Careful with this one, It needs to be True/False to match Python's booleans, not Ruby's
default['zenoss']['server']['smtp']['smtpUseTLS'] = "False"

#Performance Tweaks
default['zenoss']['server']['performance']['max_file_descriptors'] = 10240
