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

# include_recipe 'openstack-ec2api::common'

class ::Chef::Recipe # rubocop:disable Documentation
  include ::Openstack
end

identity_admin_endpoint = admin_endpoint 'identity-admin'

token = get_password 'token', 'openstack_identity_bootstrap_token'
auth_url = ::URI.decode identity_admin_endpoint.to_s

api_internal_endpoint = internal_endpoint 'ec2api-api'
api_public_endpoint = public_endpoint 'ec2api-api'
api_admin_endpoint = admin_endpoint 'ec2api-api'

#service_pass = get_password 'service', 'openstack-ec2api'
service_pass = 'ec2api'
service_tenant_name = node['openstack']['ec2api']['service_tenant']
service_user = node['openstack']['ec2api']['service_username']
service_role = node['openstack']['ec2api']['service_role']
region = node['openstack']['ec2api']['region']

# Register Image Service
openstack_identity_register 'Register Image Service' do
  auth_uri auth_url
  bootstrap_token token
  service_name 'ec2'
  service_type 'ec2'
  service_description 'EC2API Service'

  action :create_service
end

# Register Image Endpoint
openstack_identity_register 'Register Image Endpoint' do
  auth_uri auth_url
  bootstrap_token token
  service_type 'ec2'
  endpoint_region region
  endpoint_adminurl api_admin_endpoint.to_s
  endpoint_internalurl api_internal_endpoint.to_s
  endpoint_publicurl api_public_endpoint.to_s

  action :create_endpoint
end

# Register Service Tenant
openstack_identity_register 'Register Service Tenant' do
  auth_uri auth_url
  bootstrap_token token
  tenant_name service_tenant_name
  tenant_description 'Service Tenant'
  tenant_enabled true # Not required as this is the default

  action :create_tenant
end

# Register Service User
openstack_identity_register "Register #{service_user} User" do
  auth_uri auth_url
  bootstrap_token token
  tenant_name service_tenant_name
  user_name service_user
  user_pass service_pass
  # String until https://review.openstack.org/#/c/29498/ merged
  user_enabled true

  action :create_user
end

## Grant Service role to Service User for Service Tenant ##
openstack_identity_register "Grant '#{service_role}' Role to #{service_user} User for #{service_tenant_name} Tenant" do
  auth_uri auth_url
  bootstrap_token token
  tenant_name service_tenant_name
  user_name service_user
  role_name service_role

  action :grant_role
end
