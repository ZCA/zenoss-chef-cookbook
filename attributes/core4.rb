# What version of MySQL should be installed
default['zenoss']['core4']['mysql']['version'] = "5.5.28"

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

