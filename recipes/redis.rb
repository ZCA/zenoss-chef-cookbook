# Ensure Redis is installed on the system

if node['zenoss']['server']['version'] >= "4.2.4"
  include_recipe "redisio::install"
  include_recipe "redisio::enable"
else
  Chef::Log.info("Redis is only required as of version 4.2.4 or greater")
end