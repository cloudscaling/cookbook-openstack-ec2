group node['openstack']['ec2api']['group']

user node['openstack']['ec2api']['user'] do
    group node['openstack']['ec2api']['group']
    system true
    shell '/bin/bash'
end
