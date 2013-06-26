require_relative "./test_helper.rb"


include ZenossHelper

describe_recipe "zenoss::services" do
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

end