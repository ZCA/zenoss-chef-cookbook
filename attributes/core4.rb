# What version of MySQL should be installed
default['zenoss']['core4']['mysql']['version'] = "5.5.28"

#What version of RabbitMQ should be installed
default['zenoss']['core4']['rabbitmq']['version'] = "2.8.6"

#What version of RRDTool do we need
default['zenoss']['core4']['rrdtool']['version'] = "1.4.7"

# In the off chance you want to pull the RPM from somewhere else...
default['zenoss']['core4']['rpm_url'] = nil

#What version of nagios-plugins to install
default['zenoss']['core4']['nagios_plugins']['version'] = "1.4.16"

