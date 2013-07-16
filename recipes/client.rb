#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: zenoss
# Recipe:: client
#
# Copyright 2010, Zenoss, Inc
# Copyright 2010, Opscode, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


# Provide some semblance of backward compat now that the client
# stuff is moved to its own cookbook
Chef::Log.warn("Usage of #{cookbook_name}::#{recipe_name}" +
 " is deprecated. Please use zenoss_client::default instead")
include_recipe "zenoss_client"