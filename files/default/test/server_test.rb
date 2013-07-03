require_relative "./test_helper.rb"


include ZenossHelper

describe_recipe "zenoss::server" do
  describe "services" do
    it "starts the zenoss service" do
      skip "Not a supported platform" unless supported_zenoss_platform?
      service("zenoss").must_be_running
    end
    
    it "sets the zenoss service to start on book" do
      skip "Not a supported platform" unless supported_zenoss_platform?
      service("zenoss").must_be_enabled
    end
  end
  
	it "listens on the desired HTTP Port" do
    skip "Not a supported platform" unless supported_zenoss_platform?
    puts "\n"	#split up some console logging, has no actual functional value
    begin
      tries ||= 10
      http_port = node['zenoss']['server']['http_port']
      response = Net::HTTP.get_response(node[:ipaddress], "/", http_port)
    rescue
      #We don't care to do much other then let this test fail and others
      Chef::Log.info("Zenoss HTTP listner is not available yet")
      sleep(10)
      retry unless (tries -= 1).zero?
    end

    #This should return a redirect to a logon session
    response.must_be_kind_of(Net::HTTPRedirection)
	end
end