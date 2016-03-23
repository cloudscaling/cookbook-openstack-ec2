# encoding: UTF-8
#
# Cookbook Name:: openstack-ec2api
# Attributes:: database
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

# Database used by the OpenStack services
# [database.rb]
default['openstack']['db']['ec2api']['service_type'] = node['openstack']['db']['service_type']
default['openstack']['db']['ec2api']['host'] = node['openstack']['endpoints']['db']['host']
default['openstack']['db']['ec2api']['port'] = node['openstack']['endpoints']['db']['port']
default['openstack']['db']['ec2api']['db_name'] = 'ec2api'
default['openstack']['db']['ec2api']['username'] = 'ec2api'
default['openstack']['db']['ec2api']['options'] = node['openstack']['db']['options']
default['openstack']['db']['ec2api']['migrate'] = true

# [messaging.rb]
# [oslo_messaging_rabbit]
default['openstack']['mq']['ec2api']['service_type'] = node['openstack']['mq']['service_type']
default['openstack']['mq']['ec2api']['rabbit']['userid'] = 'admin'

#TODO: add password to databags
default['openstack']['db']['ec2api']['password'] = 'ec2api'
default['openstack']['ec2api']['service_password'] = 'ec2api'
