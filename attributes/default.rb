default['openstack']['ec2api']['user'] = "ec2api"
default['openstack']['ec2api']['group'] = "ec2api"


# *************************** OpenStack EC2API configuration file **********************
default['openstack']['ec2api']['conf_dir'] = '/etc/ec2api/'
default['openstack']['ec2api']['conf_file'] = 'ec2api.conf'

# [DEFAULT]
default['openstack']['ec2api']['state_path'] = '/var/lib/ec2api'

default['openstack']['ec2api']['service_username'] = 'ec2api'
default['openstack']['ec2api']['service_tenant'] = 'service'
default['openstack']['ec2api']['service_role'] = 'admin'

default['openstack']['ec2api']['verbose'] = 'True'
default['openstack']['ec2api']['debug'] = 'False'
default['openstack']['ec2api']['log_dir'] = '/var/log/ec2api'

default['openstack']['ec2api']['external_network'] = 'public'
case node['openstack']['compute']['network']['service_type']
when 'neutron'
    default['openstack']['ec2api']['vpc_support'] = 'True'
when 'nova'
    default['openstack']['ec2api']['vpc_support'] = 'False'
end
default['openstack']['ec2api']['ec2api_port'] = 8788
default['openstack']['ec2api']['logging_context_file'] = "%(asctime)s.%(msecs)03d %(levelname)s %(name)s [%(request_id)s %(user_name)s %(project_name)s] %(instance)s%(message)s"
default['openstack']['ec2api']['apipaste_file'] = "#{node['openstack']['ec2api']['conf_dir']}api-paste.ini"
default['openstack']['ec2api']['cinder_service_type'] = 'volumev2'


# [database]
default['openstack']['ec2api']['connection'] = "mysql://ec2api:ec2api@127.0.0.1/ec2api?charset=utf8"

# ***************************

default['openstack']['ec2api']['signing_dir'] = '/var/cache/ec2api'

# logging attribute
default['openstack']['ec2api']['syslog']['use'] = false
default['openstack']['ec2api']['syslog']['facility'] = 'LOG_LOCAL2'
default['openstack']['ec2api']['syslog']['config_facility'] = 'local2'

default['openstack']['ec2api']['registry']['auth']['version'] = node['openstack']['api']['auth']['version']
#default['openstack']['ec2api']['ec2authtoken']['auth']['version'] = 'v2.0'

