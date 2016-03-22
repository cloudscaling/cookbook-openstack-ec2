# encoding: UTF-8

require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'openstack-ec2api' }

require 'chef/application'

LOG_LEVEL = :fatal
UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '14.04',
  log_level: ::LOG_LEVEL
}

shared_context 'ec2-api-stubs' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('service', anything)
      .and_return('service_pass')
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('db', anything)
      .and_return('db_pass')
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('user', anything)
      .and_return('user_pass')
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('token', 'openstack_identity_bootstrap_token')
      .and_return('bootstrap-token')
    allow_any_instance_of(Chef::Recipe).to receive(:rabbit_servers)
      .and_return('1.1.1.1:5672,2.2.2.2:5672')
  end
end
