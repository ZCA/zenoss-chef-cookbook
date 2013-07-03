#Handles configuration of SSH Key related tasks

#generate SSH key for the zenoss user
ssh_key_dir = ::File.join(
    node['zenoss']['server']['zenoss_user_homedir'], ".ssh")
    
pub_key_path = ::File.join(ssh_key_dir, "id_dsa.pub")
priv_key_path = ::File.join(ssh_key_dir, "id_dsa")

execute "ssh-keygen -q -t dsa -f #{priv_key_path} -N \"\" " do
  user "zenoss"
  action :run
  not_if {File.exists?(pub_key_path)}
  notifies :create, "ruby_block[zenoss public key]", :immediate
end

#store the public key on the server as an attribute
ruby_block "zenoss public key" do
  block do
    pubkey = IO.read(pub_key_path)
    #Don't save to the server, if we are running solo
    if Chef::Config[:solo]
      Chef::Log::warn("Not Saving Key as Attribute since you are running under Chef-Solo")
    else
      node.set["zenoss"]["server"]["zenoss_pubkey"] = pubkey
      node.save
    end
  end
  action :nothing
end
 
file ::File.join(ssh_key_dir, "authorized_keys") do
  # I'm on the fence about the best approach here. This is a bit of a 
  # sledgehammer if the authorized keys is supposed to have
  # additional data...Starting with this to gauge impact
  action :create_if_missing
  content node["zenoss"]["server"]["zenoss_pubkey"]
  owner node['zenoss']['server']['zenoss_user_name']
  group node['zenoss']['server']['zenoss_group_name']
  mode "600"
end