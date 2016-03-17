# encoding: UTF-8
#
# Cookbook Name:: openstack-ec2api
# Recipe:: common
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

require 'uri'

include_recipe 'openstack-ec2api::user'

class ::Chef::Recipe # rubocop:disable Documentation
  include ::Openstack
end

if node['openstack']['ec2api']['syslog']['use']
  include_recipe 'openstack-common::logging'
end

db_user = node['openstack']['db']['ec2api']['username']
#db_pass = get_password 'db', 'ec2api'
db_pass = node['openstack']['db']['ec2api']['password']

node.default['openstack']['ec2api']['conf_secrets']
  .[]('database')['connection'] =
  db_uri_ec2api('ec2api', db_user, db_pass)

identity_endpoint = public_endpoint 'identity'
identity_admin_endpoint = admin_endpoint 'identity'
ec2_api_endpoint = internal_endpoint 'ec2api'
# node.default['openstack']['ec2api']['conf_secrets']
#   .[]('keystone_authtoken')['password'] =
#   get_password 'service', 'openstack-block-storage'
auth_url = auth_uri_transform(identity_endpoint.to_s, node['openstack']['api']['auth']['version'])
keystone_ec2_tokens_url =  uri_join_paths(auth_uri_transform(identity_endpoint.to_s,
					  node['openstack']['ec2api']['version3']), node['openstack']['ec2api']['ec2_tokens_path'])

node.default['openstack']['ec2api']['conf'].tap do |conf|
  conf['DEFAULT']['ec2_port'] = ec2_api_endpoint.port
  conf['DEFAULT']['ec2api_listen_port'] = ec2_api_endpoint.port
  conf['DEFAULT']['keystone_url'] = auth_url
  conf['DEFAULT']['keystone_ec2_tokens_url'] = keystone_ec2_tokens_url
end

ec2api_user = node['openstack']['ec2api']['user']
ec2api_group = node['openstack']['ec2api']['group']

mq_service_type = node['openstack']['mq']['ec2api']['service_type']
if mq_service_type == 'rabbit'
  user = node['openstack']['ec2api']['conf']['oslo_messaging_rabbit']['rabbit_userid']
  node.default['openstack']['ec2api']['conf_secrets']
    .[]('oslo_messaging_rabbit')['rabbit_userid'] = user
  node.default['openstack']['ec2api']['conf_secrets']
    .[]('oslo_messaging_rabbit')['rabbit_password'] = 
    get_password 'user', user
end

ec2api_config = merge_config_options 'ec2api'

directory node['openstack']['ec2api']['conf_dir'] do
  group ec2api_group
  owner ec2api_user
  mode 00700
  action :create
end

directory node['openstack']['ec2api']['conf']['DEFAULT']['log_dir'] do
  group ec2api_group
  owner ec2api_user
  mode 00755
  action :create
end

cookbook_file node['openstack']['ec2api']['conf']['DEFAULT']['api_paste_config'] do
  source 'api-paste.ini'
  owner ec2api_user
  group ec2api_group
  mode 00644
  action :create
end

template "etc/ec2api/ec2api.conf" do
  source 'openstack-service.conf.erb'
  cookbook 'openstack-common'
  group ec2api_group
  owner ec2api_user
  mode 00640
  variables(
    service_config: ec2api_config)
end

execute 'apt-get update' do
end

execute 'apt-get install -fqy libxml2-dev libxslt-dev python-dev' do
end

execute 'apt-get install -fqy python-pip' do
end

execute 'pip install ec2-api --upgrade' do    
end

openstack_common_database 'ec2api' do
  service 'ec2api' # name_attribute
  user db_user
  pass db_pass
end

execute 'ec2-api-manage db_sync' do
  user ec2api_user
  group ec2api_group
  only_if { node['openstack']['db']['ec2api']['migrate'] }
end