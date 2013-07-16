#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: zenoss
# Recipe:: server
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
class Chef::Recipe
 include ZenossHelper
end

unless node['java']['oracle']['accept_oracle_download_terms'] == true
  Chef::log.error("You have not accepted the Java License Agreement" + 
   " Please see the usage instructions of this cookbook for more " +
   " details.")
   return
end

include_recipe "#{cookbook_name}::default"

# Lets gracefully handle when running on known unsupported platforms
if supported_zenoss_platform? == false
  msg = "Sorry, running Zenoss #{node['zenoss']['server']['version']} on" +
    " #{node['platform']} version #{node['platform_version']} is know to" +
    " work properly. Skipping installation and configuration"
  Chef::Log.error(msg)
  return
end

case node['zenoss']['server']['version'].to_i
  when 3
    include_recipe "#{cookbook_name}::server3"
  when 4
    include_recipe "#{cookbook_name}::core4"
  else
    msg = "You've asked me to install a version I don't know how to handle." +
      "Please set node['zenoss']['server']['version'] to a valid version"
    Chef::Log::warn(msg)
end

include_recipe "#{cookbook_name}::configure_admin_user"
include_recipe "#{cookbook_name}::configure_smtp_settings"
