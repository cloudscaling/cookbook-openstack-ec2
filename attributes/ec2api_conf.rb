default['openstack']['ec2api']['conf'].tap do |conf|
  # [DEFAULT] section
  conf['DEFAULT']['verbose'] = true
  if node['openstack']['ec2api']['syslog']['use']
    conf['DEFAULT']['log_config'] = '/etc/openstack/logging.conf'
  else
    conf['DEFAULT']['log_dir'] = '/var/log/ec2api'
  end  
  conf['DEFAULT']['state_path'] = '/var/lib/ec2api'

  conf['DEFAULT']['admin_tenant_name'] = 'service'
  conf['DEFAULT']['admin_user'] = 'ec2api'
  conf['DEFAULT']['admin_password'] = 'ec2api' 		# add to databags

  conf['DEFAULT']['debug'] = false
  conf['DEFAULT']['full_vpc_support'] = true
  conf['DEFAULT']['external_network'] = 'public'
  conf['DEFAULT']['logging_context_format_string'] =
    '%(asctime)s.%(msecs)03d %(levelname)s %(name)s [%(request_id)s %(user_name)s %(project_name)s] %(instance)s%(message)s'
  conf['DEFAULT']['api_paste_config'] = '/etc/ec2api/api-paste.ini'
  conf['DEFAULT']['cinder_service_type'] = 'volumev2'

  # [database] section
  conf['database']['connection'] = 
    'mysql://ec2api:ec2api@127.0.0.1/ec2api?charset=utf8'

  # [oslo_messaging_rabbit] section
  conf['oslo_messaging_rabbit']['rabbit_userid'] = 'admin'

  # [keystone_authtoken] section
  conf['keystone_authtoken']['username'] = 'ec2api'
  conf['keystone_authtoken']['tenant_name'] = 'service'
  conf['keystone_authtoken']['signing_dir'] = '/var/cache/ec2api'
end
