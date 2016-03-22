# encoding: UTF-8
name 'openstack-ec2api'
maintainer 'openstack-chef'
maintainer_email 'openstack-dev@lists.openstack.org'
license 'Apache 2.0'
description 'The OpenStack EC2API service.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '13.0.0'

recipe 'openstack-ec2api::ec2-api', 'Installs the ec2api, sets up the ec2api database, and ec2api service/user/endpoints in keystone'
recipe 'openstack-ec2api::common', 'Defines the common pieces of repeated code from the other recipes'
recipe 'openstack-ec2api::identity_registration', 'Registers ec2api service/user/endpoints in keystone'
recipe 'openstack-ec2api::metadata', 'Installs the ec2api-metadata service'

%w(ubuntu).each do |os|
  supports os
end

depends 'apt', '~> 2.8'
depends 'openstack-common', '>= 13.0.0'
depends 'openstack-identity', '>= 13.0.0'
depends 'selinux', '~> 0.9.0'
depends 'python', '~> 1.4.6'
