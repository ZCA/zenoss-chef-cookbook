name             "zenoss"
maintainer       "David Petzel"
maintainer_email "davidpetzel@gmail.com"
license          "Apache 2.0"
description      "Installs and configures Zenoss and registers nodes as devices"
version          "2.0.0"
depends          "apt"
depends          "openssh"
depends          "openssl"
depends          "yum"
depends           "mysql"
depends           "java"
depends           "rabbitmq"
depends           "selinux"
depends           "zenoss_client"
depends           "redisio"
recipe           "zenoss", "Defaults to the client recipe."
recipe           "zenoss::client", "Includes the `openssh` recipe and adds the device to the Zenoss server for monitoring."
recipe           "zenoss::server", "Installs Zenoss, handling and configuring all the dependencies while adding Device Classes, Groups, Systems and Locations.  All nodes using the `zenoss::client` recipe are added for monitoring."

#start with just the .deb, perhaps switch to stack installer and/or .rpm
%w{ debian ubuntu redhat centos scientific }.each do |os|
  supports os
end

