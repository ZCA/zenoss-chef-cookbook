# Author:: David Petzel <davidpetzel@gmail.com>
# Cookbook Name:: zenoss
# Recipe:: core4

# This recipe will handle install Zenoss Core 4 on a node. This is based
# on the official installation guide on the Zenoss website

# Start by disabling SELinux
include_recipe "selinux::disabled"

#We are going need stuff from all over the internet.... OK, maybe just a few 
#places, buts its more than a single repo... Ideally some day all the packages
#we need will end up in one location...

include_recipe "yum::epel"
include_recipe "#{cookbook_name}::java"
include_recipe "#{cookbook_name}::rrdtool"
include_recipe "#{cookbook_name}::mysql55"
include_recipe "#{cookbook_name}::redis"

# Install RabbitMQ
# per Zenoss install guide section 3.2.3. Remove Conflicting Messaging Systems
%w{ matahari qpid}.each do |pkg|
  package pkg do
    action :purge
  end
end
node.default['rabbitmq']['version'] = node['zenoss']['core4']['rabbitmq']['version'] 
# On the surface this appears redundant, but at the time during testing, I noticed that even though
# we were setting 2.8.7 as the requested version, 3.x was being downloaded and installed and I
# Believe that is because of self-referencing attributes in the rabbitmq default attributes file. It appears
# that even though we are changing the value here in this recipe, that override happens after the URL
# was evaluatied, so reset the package URL location to ensure we get the version we want
# This is an exact lift from the attribute file...
node.default['rabbitmq']['package'] = "https://www.rabbitmq.com/releases/rabbitmq-server/v#{node['rabbitmq']['version']}/rabbitmq-server-#{node['rabbitmq']['version']}-1.noarch.rpm"
include_recipe "rabbitmq"

package "nagios-plugins" do
  action :install
end

#Now onto Zenoss
zenver = node['zenoss']['server']['version']
elmver= node['platform_version'].to_i #Enterprise Linux Major Version
sf_base_url = "http://sourceforge.net/projects/zenoss/files/zenoss-4.2/"
rpm_file = "zenoss_core-#{zenver}.el#{elmver}.x86_64.rpm"
rpm_dl_path = ::File.join(Chef::Config[:file_cache_path], rpm_file)

if node['zenoss']['core4']['rpm_url'] .nil?
  rpm_url = "#{sf_base_url}/zenoss-#{zenver}/#{rpm_file}/download"
else
  rpm_url = node['zenoss']['core4']['rpm_url'] 
end

remote_file rpm_dl_path do
  #Sometimes SourceForge is finicky... retry if we fail
  retries 1
  source rpm_url
  not_if "rpm -qa | grep zenoss-4"
  notifies :install, "yum_package[zenoss_core]", :immediately
end

yum_package "zenoss_core" do
  source rpm_dl_path
  options "--nogpgcheck"
  action :install
  not_if "rpm -qa | grep zenoss-4"
  only_if "test -f #{rpm_dl_path}"
end

%w{memcached snmpd rabbitmq-server zenoss}.each do |svc|
  service svc do
    action [:enable, :start]
  end
end

#Run the post_install recipe
include_recipe "#{cookbook_name}::post_install"

# The server may also be a client
include_recipe "#{cookbook_name}::client"

#Setup SSH Keys
include_recipe "#{cookbook_name}::ssh_key_config"