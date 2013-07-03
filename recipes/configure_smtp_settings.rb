# Configures SMTP Settings on a Zenoss Servers
# use zendmd to set the admin password

# TODO - Figure out how to make this idempotent
Chef::Log::info("Configuring Zenoss SMTP Settings")
zenoss_zendmd "set admin pass" do
	cmd = <<-eos
dmd.smtpHost = "#{node['zenoss']['server']['smtp']['smtpHost']}"
dmd.smtpPort = "#{node['zenoss']['server']['smtp']['smtpPort']}"
dmd.smtpUser = "#{node['zenoss']['server']['smtp']['smtpUser']}"
dmd.smtpPass = "#{node['zenoss']['server']['smtp']['smtpPass']}"
dmd.emailFrom = "#{node['zenoss']['server']['smtp']['emailFrom']}"
dmd.smtpUseTLS = #{node['zenoss']['server']['smtp']['smtpUseTLS']}
	eos
	command cmd
	action :run
end