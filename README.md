Description
===========

This cookbook installs the OpenStack EC2API service **Ec2api** as part of an OpenStack reference deployment Chef for OpenStack.

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
- Installs the python and ec2api. Setup configuration.

identity_registration
---------------------
- Registers the Ec2 API endpoint, ec2-api service and user

Installation
============

You can run this cookbook by chef-solo.


To run this cookbook in openstack-chef-repo (https://github.com/openstack/openstack-chef-repo)

0. Do **"Initial Setup Steps"** for openstack-chef-repo instruction.

Before rake deploy commands:

1. Create openstack-ec2api folder in the chef-repo cookbooks (openstack-chef-repo/cookbooks/) and add all files from this project

2. Add *./vagrant/*.json* files to the roles directory (*/openstack-chef-repo/roles/*) 

3. Add "role[os-ec2api]" to the run list in the openstack-chef-repo/roles/os-compute-single-controller.json

4. To configure OpenStack for EC2 API metadata service:

**_For Neutron_**
    
    * add to the openstack-chef-repo/enviroments/vagrant-aio-neutron.json file:
    '''bash
    "override_attributes": {
	"openstack": {
    	    "endpoints": {
        	"compute-metadata-api": {
	    	    "port": "8789"
    		}
    	    }
	}
    }
    '''

**_For Nova-network_**

    * add to the openstack-chef-repo/enviroments/vagrant-aio-nova.json file:
    '''bash
    "override_attributes": {
	"openstack": {
	    "compute": {
		"network": {
		    "neutron": {
			"service_neutron_metadata_proxy" : true
		    }
		}
	    }
	}
    }
	
    * in openstack-chef-repo/openstack-compute/templates/default/nova.conf.erb add:
    '''bash    
    [DEFAULT]
    metadata_port = 8789
    '''

5. Run "Rake Deploy Commands" for openstack-chef-repo instruction.
    
**_For Neutron_**
'''bash
$ chef exec rake aio_neutron    # All-in-one controller with Neutron
'''

**_For Nova-network_**
'''bash
$ chef exec rake aio_nova       # All-in-one controller with nova-network
'''    
    
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

Usage
=====

Download aws cli from Amazon. Create configuration file for aws cli in your home directory ~/.aws/config:

    ::
    [default]
    aws_access_key_id = 1b013f18d5ed47ae8ed0fbb8debc036b
    aws_secret_access_key = 9bbc6f270ffd4dfdbe0e896947f41df3
    region = us-east-1

Change the aws_access_key_id and aws_secret_acces_key above to the values appropriate for your cloud (can be obtained by "keystone ec2-credentials-list" command).

Run aws cli commands using new EC2 API endpoint URL (can be obtained from keystone with the new port 8788) like this::

aws --endpoint-url http://10.0.2.15:8788 ec2 describe-instances


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
