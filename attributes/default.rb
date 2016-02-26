default['openstack']['ec2api']['user'] = 'ec2api'
default['openstack']['ec2api']['group'] = 'ec2api'
default['openstack']['ec2api']['conf_dir'] = '/etc/ec2api/'
default['openstack']['ec2api']['service_role'] = 'admin'
default['openstack']['ec2api']['version3'] = 'v3.0'
default['openstack']['ec2api']['ec2_tokens_path'] = 'ec2tokens'

# logging attribute
default['openstack']['ec2api']['syslog']['use'] = false
default['openstack']['ec2api']['syslog']['facility'] = 'LOG_LOCAL2'
default['openstack']['ec2api']['syslog']['config_facility'] = 'local2'

# ******************** OpenStack EC2API Endpoints ******************************

# The OpenStack EC2API (EC2API) endpoints
%w(public internal admin).each do |ep_type|
  default['openstack']['endpoints'][ep_type]['ec2api']['path'] = ''
  default['openstack']['endpoints'][ep_type]['ec2api']['host'] = '127.0.0.1'
  default['openstack']['endpoints'][ep_type]['ec2api']['scheme'] = 'http'
  default['openstack']['endpoints'][ep_type]['ec2api']['port'] = '8788'
  default['openstack']['endpoints'][ep_type]['ec2api']['bind_interface'] = nil
end
