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

template '/etc/init/ec2-api.conf' do
    source 'ec2-api.conf.erb'
    notifies :start, 'service[ec2-api]', :immediately
end

service 'ec2-api' do
  service_name 'ec2-api'
  supports status: true, restart: true
  action :enable
end

