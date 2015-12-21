# encoding: UTF-8
#
# Cookbook Name:: openstack-ec2api
#
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
sql_connection = db_uri_ec2api('ec2api', db_user, db_pass)

identity_endpoint = internal_endpoint 'identity-internal'
identity_admin_endpoint = admin_endpoint 'identity-admin'
#service_pass = get_password 'service', 'openstack-ec2api'
service_pass = node['openstack']['ec2api']['service_password']

#ec2_auth_uri = auth_uri_transform identity_endpoint.to_s, node['openstack']['ec2api']['ec2authtoken']['auth']['version']
#puts ec2_auth_uri
auth_uri = auth_uri_transform identity_endpoint.to_s, node['openstack']['ec2api']['registry']['auth']['version']
identity_uri = identity_uri_transform(identity_admin_endpoint)

ec2api_user = node['openstack']['ec2api']['user']
ec2api_group = node['openstack']['ec2api']['group']

ec2api_listen_port = node['openstack']['ec2api']['ec2api_port']
ec2api_port = node['openstack']['ec2api']['ec2api_port']
api_paste_config = node['openstack']['ec2api']['api_paste_file']
logging_context_format_string = "%(asctime)s.%(msecs)03d %(levelname)s %(name)s [%(request_id)s %(user_name)s %(project_name)s] %(instance)s%(message)s"
log_dir = node['openstack']['ec2api']['log_dir']
verbose = node['openstack']['ec2api']['verbose']
keystone_url = auth_uri
connection = node['openstack']['ec2api']['connection']
vpc_support = node['openstack']['ec2api']['vpc_support']
external_network = node['openstack']['ec2api']['external_network']

admin_user = node['openstack']['ec2api']['service_username']
admin_password = node['openstack']['ec2api']['service_password']
admin_tenant_name = node['openstack']['ec2api']['service_tennant']

mq_service_type = node['openstack']['mq']['ec2api']['service_type']
if mq_service_type == 'rabbitmq'
  if node['openstack']['mq']['ec2api']['rabbit']['ha']
    rabbit_hosts = rabbit_servers
  end
  mq_password = get_password 'user', node['openstack']['mq']['ec2api']['rabbit']['userid']
elsif mq_service_type == 'qpid'
  mq_password = get_password 'user', node['openstack']['mq']['ec2api']['qpid']['username']
end

directory node['openstack']['ec2api']['conf_dir'] do
  group ec2api_group
  owner ec2api_user
  mode 00700
  action :create
end

directory node['openstack']['ec2api']['log_dir'] do
  group ec2api_group
  owner ec2api_user
  mode 00755
  action :create
end

cookbook_file node['openstack']['ec2api']['apipaste_file'] do
  source 'api-paste.ini'
  owner ec2api_user
  group ec2api_group
  mode 00644
  action :create
end

template "etc/ec2api/ec2api.conf" do
  source 'ec2api.conf.erb'
  group ec2api_group
  owner ec2api_user
  mode 00644
  variables(
    ec2api_listen_port: ec2api_listen_port,
    ec2api_port: ec2api_port,
    api_paste_config: api_paste_config,
    logging_context_format_string: logging_context_format_string,
    log_dir: log_dir,
    verbose: verbose,
    rabbit_hosts: rabbit_hosts,
    keystone_url: keystone_url,
    connection: connection,
    full_vpc_support: vpc_support,
    external_network: external_network,
    mq_password: mq_password,

    admin_user: admin_user,
    admin_password: admin_password,
    admin_tenant_name: admin_tenant_name)
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
