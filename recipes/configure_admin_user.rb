# Recipe for manipulating the default/built-in admin user
# use zendmd to set the admin password and other attributes

# TODO - Figure out how to make this idempotent
zenoss_zendmd "configure admin user" do
	cmd = <<-eos
app.acl_users.userManager.updateUserPassword('admin', '#{node['zenoss']['server']['admin_password']}')
dmd.ZenUsers.admin.email = "#{node['zenoss']['server']['admin_email_address']}"
dmd.ZenUsers.admin.pager = "#{node['zenoss']['server']['admin_pager_address']}"
	eos
  command cmd
  action :run
end