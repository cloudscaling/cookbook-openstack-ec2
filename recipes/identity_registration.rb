# encoding: UTF-8
#
# Cookbook Name:: openstack-image
# Recipe:: identity_registration
#
# Copyright 2013, AT&T Services, Inc.
# Copyright 2013, Craig Tracey <craigtracey@gmail.com>
# Copyright 2013, Opscode, Inc.
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

class ::Chef::Recipe # rubocop:disable Documentation
  include ::Openstack
end

identity_admin_endpoint = admin_endpoint 'identity'

token = get_password 'token', 'openstack_identity_bootstrap_token'
auth_uri = ::URI.decode identity_admin_endpoint.to_s
internal_ec2api_api_endpoint = internal_endpoint 'ec2api'
public_ec2api_api_endpoint = public_endpoint 'ec2api'
admin_ec2api_api_endpoint = admin_endpoint 'ec2api'

#service_pass = get_password 'service', 'openstack-ec2api' 
service_pass = 'ec2api' # add ec2api to databags
service_tenant_name = 
    node['openstack']['ec2api']['conf']['keystone_authtoken']['tenant_name']
service_user = 
    node['openstack']['ec2api']['conf']['keystone_authtoken']['username']
service_role = node['openstack']['ec2api']['service_role']
service_name = 'ec2'
service_type = 'ec2'
region = node['openstack']['region']

# Register Service Tenant
openstack_identity_register 'Register Service Tenant' do
  auth_uri auth_uri
  bootstrap_token token
  tenant_name service_tenant_name
  tenant_description 'Service Tenant'
  action :create_tenant
end

# Register EC2API Service
openstack_identity_register 'Register EC2API Service' do
  auth_uri auth_uri
  bootstrap_token token
  service_name service_name
  service_type service_type
  service_description 'EC2API Service'
  endpoint_region region
  endpoint_adminurl ::URI.decode admin_ec2api_api_endpoint.to_s
  endpoint_internalurl ::URI.decode internal_ec2api_api_endpoint.to_s
  endpoint_publicurl ::URI.decode public_ec2api_api_endpoint.to_s
  action :create_service
end

# Register EC2API Endpoint
openstack_identity_register 'Register EC2API Endpoint' do
  auth_uri auth_uri
  bootstrap_token token
  service_type service_type
  endpoint_region region
  endpoint_adminurl ::URI.decode admin_ec2api_api_endpoint.to_s
  endpoint_internalurl ::URI.decode internal_ec2api_api_endpoint.to_s
  endpoint_publicurl ::URI.decode public_ec2api_api_endpoint.to_s
  action :create_endpoint
end

# Register Service User
openstack_identity_register 'Register EC2API User' do
  auth_uri auth_uri
  bootstrap_token token
  tenant_name service_tenant_name
  user_name service_user
  user_pass service_pass
  action :create_user
end

# Grant Service role to Service User for Service Tenant ##
openstack_identity_register "Grant '#{service_role}' Role to #{service_user} User for #{service_tenant_name} Tenant" do
  auth_uri auth_uri
  bootstrap_token token
  tenant_name service_tenant_name
  user_name service_user
  role_name service_role
  action :grant_role
end
