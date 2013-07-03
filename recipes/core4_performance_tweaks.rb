
# Everything in here needs to be revamped, and as such
# This is currently not included in the run_list by default.
# TODO - I'm pretty sure we should be able go to do away with this
# grossness, by  leveraging the sysctl and memcached cookbooks.
# So the TODO here is to clean this up and get what it does baked
# into the core4 recipe

ruby_block "Increase Allow File descriptors" do
	block do
		fe = Chef::Util::FileEdit.new("/etc/security/limits.conf")
		fe.insert_line_if_no_match(/zenoss - nofile \d+/, 
									"zenoss - nofile #{node['zenoss']['server']['performance']['max_file_descriptors']}")
		fe.write_file
	end
end

ruby_block "set memcached CACHESIZE based on zope.conf" do
	block do
		current_cache_local_mb = ::File.read("#{node['zenoss']['server']['zenhome']}/etc/zope.conf").scan(/cache-local-mb (\d+)/)[0][0]
		current_memcached_cache_size = ::File.read("/etc/sysconfig/memcached").scan(/CACHESIZE="(\d+)"/)[0][0]
		if current_cache_local_mb * 2 < current_memcached_cache_size
			new_memcached_cache_size = 1024
		else
			new_memcached_cache_size = current_cache_local_mb * 2
		end
		puts current_cache_local_mb
		puts current_memcached_cache_size
		puts new_memcached_cache_size
		
		fe = Chef::Util::FileEdit.new("/etc/sysconfig/memcached")
		fe.search_file_replace_line(/CACHESIZE=\"\d+\"/, 
									"CACHESIZE=\"#{new_memcached_cache_size}\"")
		fe.write_file

	end
end
