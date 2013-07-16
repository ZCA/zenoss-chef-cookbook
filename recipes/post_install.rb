# Once Zenoss is installed, there are some additional configurations
# we can set to streamline things

# skip the new install Wizard.
zenoss_zendmd "skip setup wizard" do
  command "dmd._rq = True"
  only_if { node['zenoss']['server']['skip_setup_wizard'] == true }
  action :run
end