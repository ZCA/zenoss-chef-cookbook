# What version of MySQL should be installed
default['zenoss']['core4']['mysql']['version'] = "5.5.28"

# MySQL community repository
case node['platform_family']
when 'rhel'
  case node['platform_version'].to_i
  when 5
    # Apparently 5.5-community-release for EL5, is in the 5.6-community directory?
    default['zenoss']['core4']['mysql']['community-repo-source'] = "https://repo.mysql.com/yum/mysql-5.6-community/el/#{node['platform_version'].to_i}/#{node['kernel']['machine']}/mysql-community-release-el5-5.noarch.rpm"
  when 6
    default['zenoss']['core4']['mysql']['community-repo-source'] = "https://repo.mysql.com/yum/mysql-5.5-community/el/#{node['platform_version'].to_i}/#{node['kernel']['machine']}/mysql-community-release-el6-5.noarch.rpm"
  end
end

#What version of RabbitMQ should be installed
default['zenoss']['core4']['rabbitmq']['version'] = "2.8.6"

#What version of RRDTool do we need
default['zenoss']['core4']['rrdtool']['version'] = "1.4.7"

# In the off chance you want to pull the RPM from somewhere else...
# If you set this value to anything other than nil, this URL will be used
# instead of the SourceForge URL
default['zenoss']['core4']['rpm_url'] = nil

#What version of nagios-plugins to install
default['zenoss']['core4']['nagios_plugins']['version'] = "1.4.16"

default['mysql']['server_debian_password'] = 'password'
default['mysql']['server_root_password'] = 'password'
default['mysql']['server_repl_password'] = 'password'
