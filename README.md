Description
===========

This cookbook installs the OpenStack EC2API service **ec2api** as part of an OpenStack reference deployment Chef for OpenStack.

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

ec2-api
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
- Installs the python and ec2api. Setup configuration.

identity_registration
---------------------
- Registers the EC2API endpoint, ec2-api service and user

Installation
============

To run this cookbook in openstack-chef-repo (https://github.com/openstack/openstack-chef-repo)

0. Do **"Initial Setup Steps"** for openstack-chef-repo instruction.

Before rake deploy commands:

1. Create openstack-ec2api folder in the chef-repo cookbooks (*/openstack-chef-repo/cookbooks/*) and add all files from this project

2. Add to the run list in the */openstack-chef-repo/roles/allinone.json*
```
    "recipe[openstack-ec2api::ec2-api]",
    "recipe[openstack-ec2api::metadata]",
    "recipe[openstack-ec2api::identity_registration]"
```

3. To configure OpenStack for EC2 API metadata service:

**_For Neutron_**
* add to the openstack-chef-repo/enviroments/vagrant-aio-neutron.json file:

```
  "override_attributes": {
    "openstack": {
      "network_metadata":{
        "conf": {
          "DEFAULT": {
            "nova_metadata_port": "8789"
          }
        }
      }
    }
  }

```

4. Run **"Rake Deploy Commands"** for openstack-chef-repo instruction.
    
```
$ chef exec rake allinone    # All-in-one controller with Neutron
```
    
Attributes
==========

Attributes for the EC2API service are in the ['openstack']['ec2api'] namespace.

* 'openstack['ec2api']['user']' - User ec2api runs as.
* 'openstack['ec2api']['group']' - Group ec2api runs as.
* 'openstack['ec2api']['conf_dir']' - Defaults to '/etc/ec2api'. Directory for configuration and paste.ini file.
* 'openstack['ec2api']['service_role']' - User role used by ec2api when interacting with keystone - used in the API and registry paste.ini files.
* 'openstack['ec2api']['ec2_tokens']' - URL to authenticate token from ec2 request.

# logging attribute
* 'openstack['ec2api']['syslog']['use']' - Should heat log to syslog?
* 'openstack['ec2api']['syslog']['facility']' - Which facility heat should use when logging in python style (for example, `LOG_LOCAL1`)
* 'openstack['ec2api']['syslog']['config_facility']' - Which facility heat should use when logging in rsyslog style (for example, local1)

MQ attributes
-------------
* 'openstack['mq']['ec2api']['service_type']' - Select qpid or rabbitmq. default rabbitmq
* 'openstack['mq']['ec2api']['rabbit']['userid']' - Username for rabbit access

The OpenStack EC2API API endpoint
-------------
* 'openstack['endpoints']['ec2api'][ep_type]['host']' - The IP address to bind the service to
* 'openstack['endpoints']['ec2api'][ep_type]['path']' - The path to bind the service to
* 'openstack['endpoints']['ec2api'][ep_type]['scheme']' - The scheme to bind the service to
* 'openstack['endpoints']['ec2api'][ep_type]['port']' - The port to bind the service to
* 'openstack['endpoints']['ec2api'][ep_type]['bind_interface']' - The interface name to bind the service to

#TODO: add password to databags
* 'openstack['db']['ec2api']['password']' - The password for the database.
* 'openstack['ec2api']['service_password']' - The password for service_tenant.

Usage
=====

Download aws cli from Amazon. Create configuration file for aws cli in your home directory ~/.aws/config:

    [default]
    aws_access_key_id = 1b013f18d5ed47ae8ed0fbb8debc036b
    aws_secret_access_key = 9bbc6f270ffd4dfdbe0e896947f41df3
    region = RegionOne

Change the aws_access_key_id and aws_secret_acces_key above to the values appropriate for your cloud (can be obtained by *"keystone ec2-credentials-list"* command).

Run aws cli commands using new EC2 API endpoint URL (can be obtained from keystone with the new port 8788) like this::

    aws --endpoint-url http://127.0.0.1:8788 ec2 describe-instances


License
=======

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.