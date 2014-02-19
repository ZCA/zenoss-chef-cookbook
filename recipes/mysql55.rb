# The MySQL Cookbook doesn't seem to currently handle 5.5 on 
# RHEL
# TODO - Move this to community MySQL Cookbooks

%w{ mysql-client-5.1 mysql-client-core-5.1 mysql-common 
        mysql-server mysql-server-5.1 mysql-server-core-5.1 
        mysql-connector-odbc mysql-libs 
 }.each do |pkg|
  package pkg do
    action :purge
  end
end

if node['platform_family'] != "rhel"
  node.set['mysql']['version'] = node['zenoss']['core4']['mysql']['version']
  include_recipe "mysql::server"
else
  # Turn off table_cache in Opscode my.cnf
  node.default['mysql']['version'] = 5.6

  # Download community repo file to Chef cache
  remote_file "#{Chef::Config['file_cache_path']}/mysql-5.5-community-repo.rpm" do
    source node['zenoss']['core4']['mysql']['community-repo-source']
  end

  # Install community repo
  package "#{Chef::Config['file_cache_path']}/mysql-5.5-community-repo.rpm"

  # Override Opscode package list
  node.default['mysql']['client']['packages'] = %w[mysql-community-client mysql-community-devel]
  node.default['mysql']['server']['packages'] = %w[mysql-community-libs-compat mysql-community-server]

  # Configure MySQL server
  include_recipe 'mysql::server'
end
