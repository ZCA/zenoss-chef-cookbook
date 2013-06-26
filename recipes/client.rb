#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: zenoss
# Recipe:: client
#
# Copyright 2010, Zenoss, Inc
# Copyright 2010, Opscode, Inc
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

include_recipe "openssh"

#create a 'zenoss' user for monitoring
user "zenoss" do
  comment "Zenoss monitoring account"
  home "/home/zenoss" unless node["os"] == "windows"
  supports :manage_home => true unless node["os"] == "windows"
  shell "/bin/bash" unless node["os"] == "windows"
  action :create
end

#create a home directory for them
directory "/home/zenoss/.ssh" do
  owner "zenoss"
  mode "0700"
  action :create
  not_if { node["os"] == "windows" }
end

#get the zenoss user public key via search
if Chef::Config["solo"]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
  server = []
else
  server = search(:node, 'recipes:zenoss\:\:server') || []
end


if server.length > 0
  zenoss = server[0]["zenoss"]
  if zenoss["server"] and zenoss["server"]["zenoss_pubkey"]
    pubkey = zenoss["server"]["zenoss_pubkey"]
    file "/home/zenoss/.ssh/authorized_keys" do
      backup false
      owner "zenoss"
      mode "0600"
      content pubkey
      action :create
      not_if { node["os"] == "windows" }
    end
  else
    Chef::Log.info("No Zenoss server found, device is unmonitored.")
  end
else
  Chef::Log.info("No Zenoss server found, device is unmonitored.")
end
