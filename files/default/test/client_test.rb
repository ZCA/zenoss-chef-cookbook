require_relative "./test_helper.rb"

describe_recipe "zenoss::client" do
  describe "users and groups" do
    it "creates the zenoss user" do
      user("zenoss").must_exist
      user("zenoss").must_have(:home, "/home/zenoss") unless node[:os] == "windows"
      user("zenoss").must_have(:comment, 'Zenoss monitoring account') unless node[:os] == "windows"
    end
  end
  
  describe "directories" do
    it "creates the zenoss user's .ssh directory" do
      directory("/home/zenoss/.ssh").must_exist.with(:owner, "zenoss") unless node[:os] == "windows"
    end
  end
end