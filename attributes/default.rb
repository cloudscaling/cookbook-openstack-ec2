# encoding: UTF-8
#
# Cookbook Name:: openstack-ec2api
# Attributes:: default
#
# Copyright 2016, EMC Corporation.
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

default['openstack']['ec2api']['user'] = 'ec2api'
default['openstack']['ec2api']['group'] = 'ec2api'
default['openstack']['ec2api']['conf_dir'] = '/etc/ec2api'
default['openstack']['ec2api']['service_role'] = 'admin'
default['openstack']['ec2api']['version3'] = 'v3.0'
default['openstack']['ec2api']['ec2_tokens_path'] = 'ec2tokens'

# logging attribute
default['openstack']['ec2api']['syslog']['use'] = false
default['openstack']['ec2api']['syslog']['facility'] = 'LOG_LOCAL2'
default['openstack']['ec2api']['syslog']['config_facility'] = 'local2'

# packages
default['openstack']['ec2api']['packages'] = %w(libxml2-dev libxslt1-dev python-dev)
default['openstack']['ec2api']['package_overrides'] = "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"

# ******************** OpenStack EC2API Endpoints ******************************

# The OpenStack EC2API (EC2API) endpoints
%w(public internal admin).each do |ep_type|
  default['openstack']['endpoints'][ep_type]['ec2api']['path'] = ''
  default['openstack']['endpoints'][ep_type]['ec2api']['host'] = '127.0.0.1'
  default['openstack']['endpoints'][ep_type]['ec2api']['scheme'] = 'http'
  default['openstack']['endpoints'][ep_type]['ec2api']['port'] = '8788'
  default['openstack']['endpoints'][ep_type]['ec2api']['bind_interface'] = nil
end
