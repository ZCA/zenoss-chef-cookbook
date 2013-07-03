# Helper library to help abstract some logic nastiness out of recipes

module ZenossHelper
  # Is this a supported platform for Zenoss Core to run on
  #
  # @return [Boolean]
  def supported_zenoss_platform?
    supported_platform = false
    case node['zenoss']['server']['version'].to_i
      when 3
        supported_platform = true if node['platform_family'] == "rhel" and node['platform_version'].to_i == 5
        supported_platform = true if node['platform'] == "ubuntu" and node['platform_version'] == 10
      when 4
        # Core 4 only supports 64 bit, your out of luck on 32 bit
        if node['kernel']['machine'] == "x86_64"
          supported_platform = true if node['platform_family'] == "rhel" and node['platform_version'].to_i >= 5
        end
    end
    return supported_platform
  end

end