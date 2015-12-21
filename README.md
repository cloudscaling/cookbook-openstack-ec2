Description
===========

This cookbook installs the OpenStack EC2API service **Ec2api** as part of an OpenStack reference deployment Chef for OpenStack.
To run this cookbook in installation of Openstack by openstack-chef-repo cookbook, please read README file in vagrant folder.

Requirements
============

Chef 11 or higher required (for Chef environment use).

Cookbooks
---------

The following cookbooks are dependencies:

* openstack-common
* openstack-identity

Usage
=====

api
------
- Configure and start ec2-api service

metadata
------
- Configure and start ec2api-metadata service

user
----
- Create the ec2api user

common
------
- Installs the python and ec2api and setup configuration.

identity_registration
---------------------
- Registers the Ec2 API endpoint, ec2-api service and user

Attributes
==========

Attributes for the EC2API service are in the ['openstack']['ec2api'] namespace.


* 'openstack['ec2api']['user']' - User ec2api runs as
* 'openstack['ec2api']['group']' - Group ec2api runs as
* 'openstack['ec2api']['conf_dir']` - Defaults to `/etc/ec2api`. Directory for configuration and paste.ini file.'
* 'openstack['ec2api']['conf_file']' - Configuration file for ec2api 
* 'openstack['ec2api']['state_path']` - Top-level directory for maintaining ec2api's state
* 'openstack['ec2api']['service_username']` - User name used by ec2api when interacting with keystone - used in the API and registry paste.ini files
* 'openstack['ec2api']['service_tenant']` - Tenant name used by ec2api when interacting with keystone - used in the API and registry paste.ini files
* 'openstack['ec2api']['service_role']` - User role used by ec2api when interacting with keystone - used in the API and registry paste.ini files
* 'openstack['ec2api']['verbose']` - Enables/disables verbose output for ec2api services.
* 'openstack['ec2api']['debug']` - Enables/disables debug output for ec2api services.
* 'openstack['ec2api']['log_dir']' - The directory for logs.
* 'openstack['ec2api']['external_network']' - Name of the external network, which is used to connect VPCs to Internet and to allocate Elastic IPs.
* 'openstack['ec2api']['vpc_support']' - True if server supports Neutron for full VPC access.
* 'openstack['ec2api']['ec2api_port']' - The ec2api port to use.
* 'openstack['ec2api']['logging_context_file']' - Format string to use for log messages with context.
* 'openstack['ec2api']['apipaste_file']' - File name for the paste.deploy config for ec2api.
# [database]
* 'openstack['ec2api']['connection']' - The URL for database connection.
* 'openstack['ec2api']['signing_dir']' - Keystone PKI needs a location to hold the signed tokens.
# logging attribute
* 'openstack['ec2api']['syslog']['use']' - Should heat log to syslog?
* 'openstack['ec2api']['syslog']['facility']' - Which facility heat should use when logging in python style (for example, `LOG_LOCAL1`)
* 'openstack['ec2api']['syslog']['config_facility']' - Which facility heat should use when logging in rsyslog style (for example, local1)
* 'openstack['ec2api']['registry']['auth']['version']' - Default v2.0. The auth API version used to interact with identity service.

MQ attributes
-------------
* 'openstack['mq']['ec2api']['service_type']` - Select qpid or rabbitmq. default rabbitmq
* 'openstack['mq']['ec2api']['rabbit']['userid']` - Username for rabbit access
# The OpenStack EC2API API endpoint
* 'openstack['endpoints']['ec2api-api']['host']` - The IP address to bind the service to
* 'openstack['endpoints']['ec2api-api']['scheme']` - The scheme to bind the service to
* 'openstack['endpoints']['ec2api-api']['port']` - The port to bind the service to
* 'openstack['endpoints']['ec2api-api']['bind_interface']` - The interface name to bind the service to
#TODO: add password to databags
* 'openstack['db']['ec2api']['password']` - The password for the database.
* 'openstack['ec2api']['service_password']` - The password for service_tenant.

Testing
=====


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
