# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-ec2api::identity_registration' do
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    include_context 'ec2-api-stubs'

    it 'registers service tenant' do
      expect(chef_run).to create_tenant_openstack_identity_register(
        'Register Service Tenant'
      ).with(
        auth_uri: 'http://127.0.0.1:35357/v2.0',
        bootstrap_token: 'bootstrap-token',
        tenant_name: 'service',
        tenant_description: 'Service Tenant'
      )
    end

    it 'registers ec2api service' do
      expect(chef_run).to create_service_openstack_identity_register(
        'Register EC2API Service'
      ).with(
        auth_uri: 'http://127.0.0.1:35357/v2.0',
        bootstrap_token: 'bootstrap-token',
        service_name: 'ec2',
        service_type: 'ec2',
        service_description: 'EC2API Service'
      )
    end

    it 'registers ec2api endpoint' do
      expect(chef_run).to create_endpoint_openstack_identity_register(
        'Register EC2API Endpoint'
      ).with(
        auth_uri: 'http://127.0.0.1:35357/v2.0',
        bootstrap_token: 'bootstrap-token',
        service_type: 'ec2',
        endpoint_region: 'RegionOne',
        endpoint_adminurl: 'http://127.0.0.1:8788',
        endpoint_internalurl: 'http://127.0.0.1:8788',
        endpoint_publicurl: 'http://127.0.0.1:8788'
      )
    end

    it 'registers ec2api service user' do
      expect(chef_run).to create_user_openstack_identity_register(
        'Register EC2API Service User'
      ).with(
        auth_uri: 'http://127.0.0.1:35357/v2.0',
        bootstrap_token: 'bootstrap-token',
        tenant_name: 'service',
        user_name: 'ec2api',
        user_pass: 'ec2api'
      )
    end

    it 'grants admin role to service user for service tenant' do
      expect(chef_run).to grant_role_openstack_identity_register(
        'Grant admin Role to EC2API Service User for EC2API Service Tenant'
      ).with(
        auth_uri: 'http://127.0.0.1:35357/v2.0',
        bootstrap_token: 'bootstrap-token',
        tenant_name: 'service',
        role_name: 'admin',
        user_name: 'ec2api'
      )
    end
  end
end
