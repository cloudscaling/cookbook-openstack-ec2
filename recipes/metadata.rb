# encoding: UTF-8
#
# Cookbook Name:: openstack-orchestration
# Recipe:: engine
#
# Copyright 2013, IBM Corp.
# Copyright 2014, SUSE Linux, GmbH.
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
require 'uri'

include_recipe 'openstack-ec2api::common'

class ::Chef::Recipe # rubocop:disable Documentation
  include ::Openstack
end

ec2api_user = node['openstack']['ec2api']['user']
ec2api_group = node['openstack']['ec2api']['group']

template '/etc/init/ec2-api-metadata.conf' do
    source 'metadata.conf.erb'
    notifies :start, 'service[ec2-api-metadata]', :immediately
end

service 'ec2-api-metadata' do
  service_name 'ec2-api-metadata'
  supports status: true, restart: true

  action :enable
end
