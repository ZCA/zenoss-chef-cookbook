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

# Ensure a blank password (at least for now) for mysql
# We have to do node.set rather than node.default for this one
# as the mysql::server recipe uses some set_unless magic so the
# value has to be set at the 'normal' attribute level
node.set['mysql']['version'] = node['zenoss']['core4']['mysql']['version']
node.set['mysql']['server_root_password'] = ''

if node['platform_family'] != "rhel"
  include_recipe "mysql::server"
else
  mysql_ver = node['zenoss']['core4']['mysql']['version']
  pv = node['platform_version'].to_i
  arch = node['kernel']['machine']
  # Add more logic fun. On rhel 6 they use a string of el6 in the file name
  # howeve on rhel 5 they spell it out as rhel5
  if pv == 6
    el_id = "el"
  else
    el_id = "rhel"
  end
  
  mysql_rpms = {
    "MySQL-client" => {
      'rpm_file' => "MySQL-client-#{mysql_ver}-1.#{el_id}#{pv}.#{arch}.rpm"
    },
    "MySQL-server" => {
      'rpm_file' => "MySQL-server-#{mysql_ver}-1.#{el_id}#{pv}.#{arch}.rpm"
    },
    "MySQL-shared" => {
      'rpm_file' => "MySQL-shared-#{mysql_ver}-1.#{el_id}#{pv}.#{arch}.rpm"
    }
  }

  mysql_rpms.each do |name, details|
    remote_file "#{Chef::Config[:file_cache_path]}/#{details['rpm_file']}" do
      source "http://downloads.mysql.com/archives/mysql-5.5/#{details['rpm_file']}"
      notifies :install, "yum_package[#{name}]", :immediately
      # If the package is already installed, don't bother downloading it
      not_if "rpm -qa | grep -i #{name.gsub('.rpm', '')}"
    end
    
    yum_package name do
      source "#{Chef::Config[:file_cache_path]}/#{details['rpm_file']}"
      options "--nogpgcheck"
      not_if "rpm -qa | grep -i #{name.gsub('.rpm', '')}"
      action :nothing
    end
  end
  
  service "mysql" do
    action [:enable, :start]
  end
end


