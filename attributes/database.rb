# ### TODO: add attributes to the openstack-common project ###

# Database used by the OpenStack services
# [database.rb]
project = 'ec2api'

default['openstack']['db']['ec2api']['service_type'] = node['openstack']['db']['service_type']
default['openstack']['db']['ec2api']['host'] = node['openstack']['endpoints']['db']['host']
default['openstack']['db']['ec2api']['port'] = node['openstack']['endpoints']['db']['port']
default['openstack']['db']['ec2api']['db_name'] = project
default['openstack']['db']['ec2api']['username'] = project
default['openstack']['db']['ec2api']['options'] = node['openstack']['db']['options']

default['openstack']['db']['ec2api']['migrate'] = true

# [messaging.rb]
# [oslo_messaging_rabbit]
default['openstack']['mq']['ec2api']['service_type'] = 'rabbitmq'
default['openstack']['mq']['ec2api']['rabbit']['userid'] = 'admin'

# [default.rb]
# The OpenStack EC2API API endpoint
default['openstack']['endpoints']['ec2api-api']['host'] = node['openstack']['endpoints']['host']
default['openstack']['endpoints']['ec2api-api']['scheme'] = node['openstack']['endpoints']['scheme']
default['openstack']['endpoints']['ec2api-api']['port'] = '8788'
default['openstack']['endpoints']['ec2api-api']['path'] = ''
default['openstack']['endpoints']['ec2api-api']['bind_interface'] = nil


#TODO: add password to databags
default['openstack']['db']['ec2api']['password'] = 'ec2api'
default['openstack']['ec2api']['service_password'] = "ec2api"