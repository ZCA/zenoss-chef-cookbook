# Make sure OpenJDK is not installed
package "java-openjdk" do
  action :purge
end

# Install Java. Zenoss requires that it be Oracle
node.default['java']['install_flavor'] = "oracle"
node.default['java']['jdk_version'] = '6'

# On RHEL use RPMs so we can satisfy zenoss RPM dependencies
if platform_family?("rhel")
  # The java cookbook currently barks if you give the RPM URL with something like:
  #FATAL:  Command ' mv "/tmp/d20130528-2410-f17dz2/jre1.6.0_45" "/usr/lib/jvm/jre1.6.0_45" ' failed
  # It works fine, if you pass it the non rpm file, but the zenoss RPM enforces a package
  # dependency
  
  # So we are going to do it the old fashion way
  download_file = "jre-6u45-linux-x64-rpm.bin"
  remote_file ::File.join(Chef::Config[:file_cache_path], download_file) do
    action :create
    checksum "14b5f623739f09a9b36f3d2509aa089cc4d08d0520facf087ae015d417884c50"
    source "http://javadl.sun.com/webapps/download/AutoDL?BundleId=76202"
    mode "0550"
    notifies :run, "execute[install_jre_rpm]", :immediately
  end
  
  execute "install_jre_rpm" do
    command ::File.join(Chef::Config[:file_cache_path], download_file)
    # Only when notified
    action :nothing
  end
else
  include_recipe "java"
end
