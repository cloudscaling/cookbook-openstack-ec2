# Encoding: utf-8
#
# Cookbook Name:: openstack-ec2api
# Spec:: common_spec
#
# Copyright 2016, EMC Corporation.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributsed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative 'spec_helper'

describe 'openstack-ec2api::common' do
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    include_context 'ec2-api-stubs'

    it 'includes ec2api user recipe' do
      expect(chef_run).to include_recipe('openstack-ec2api::user')
    end

#    it 'includes python pip recipe' do
#      expect(chef_run).to include_recipe('python::pip')
#    end

    describe '/var/log/ec2api' do
      let(:dir) { chef_run.directory('/var/log/ec2api') }

      it 'should create the directory' do
        expect(chef_run).to create_directory(dir.name).with(
          user: 'ec2api',
          group: 'ec2api',
          mode: 0755
        )
      end
    end

    describe '/etc/ec2api' do
      let(:dir) { chef_run.directory('/etc/ec2api') }

      it 'should create the directory' do
        expect(chef_run).to create_directory(dir.name).with(
          user: 'ec2api',
          group: 'ec2api',
          mode: 0750
        )
      end
    end

    describe 'api-paste.ini' do
      let(:file) { chef_run.template('/etc/ec2api/api-paste.ini') }

      it 'should create the api-paste template' do
        expect(chef_run).to create_template(file.name).with(
          user: 'ec2api',
          group: 'ec2api',
          mode: 0644
        )
      end
    end

    describe 'ec2api.conf' do
      let(:file) { chef_run.template('/etc/ec2api/ec2api.conf') }

      it 'should create the ec2api.conf template' do
        expect(chef_run).to create_template(file.name).with(
          user: 'ec2api',
          group: 'ec2api',
          mode: 0640
        )
      end

      it 'has the default attributes' do
        [
          /^verbose = true$/,
	  %r{^log_dir = /var/log/ec2api$},
	  %r{^state_path = /var/lib/ec2api$},
	  /^admin_tenant_name = service$/,
	  /^admin_user = ec2api$/,
	  /^admin_password = ec2api$/,
	  /^debug = false$/,
	  /^full_vpc_support = true$/,
	  /^external_network = public$/,
#	  %r{^logging_context_format_string = %(asctime)s.%(msecs)03d %(levelname)s %(name)s [%(request_id)s %(user_name)s %(project_name)s] %(instance)s%(message)s$},
	  %r{^api_paste_config = /etc/ec2api/api-paste.ini$},
	  /^cinder_service_type = volumev2$/,
	  /^ec2_port = 8788$/,
	  /^ec2api_listen_port = 8788$/,
	  %r{^keystone_url = http://127.0.0.1:5000/v2.0$},
	  %r{^keystone_ec2_tokens_url = http://127.0.0.1:5000/v3/ec2tokens$}
        ].each do |line|
          expect(chef_run).to render_config_file(file.name).with_section_content('DEFAULT', line)
        end
      end

      it 'has the default database attributes' do
        [
          %r{^connection = mysql://ec2api:ec2api@127.0.0.1:3306/ec2api\?charset=utf8$},
#          %r{^connection = mysql://ec2api:ec2api@127.0.0.1:3306/ec2api?charset=utf8$},
        ].each do |line|
          expect(chef_run).to render_config_file(file.name).with_section_content('database', line)
        end
      end

      it 'has the default oslo_messaging_rabbit attributes' do
        [
          /^rabbit_userid = admin$/,
          /^rabbit_password = user_pass$/
        ].each do |line|
          expect(chef_run).to render_config_file(file.name).with_section_content('oslo_messaging_rabbit', line)
        end
      end
    end

    describe 'expect installs python package' do
      it 'installs libxml2-dev packages by default' do
        expect(chef_run).to upgrade_package 'libxml2-dev'
      end

      it 'installs libxslt-dev packages by default' do
        expect(chef_run).to upgrade_package 'libxslt1-dev'
      end

      it 'installs python-dev packages by default' do
        expect(chef_run).to upgrade_package 'python-dev'
      end
    end

    describe 'expect upgrades ec2api package' do

      it 'installs python-pip' do
        expect(chef_run).to upgrade_package('python-pip')
      end

      it 'installs/upgrades ec2api' do
	expect(chef_run).to run_execute('pip install ec2-api --upgrade')
      end

#      it 'upgrades ec2api package' do
#        expect(chef_run).to upgrade_python_pip('ec2-api')
#      end
    end

     it 'creates the openstack_common_database' do
      expect(chef_run).to create_openstack_common_database('ec2api')
        .with(user: 'ec2api', pass: 'ec2api')
    end

    describe 'db_sync' do
      let(:cmd) { 'ec2-api-manage db_sync' }

      it 'runs migrations' do
        expect(chef_run).to run_execute(cmd).with(user: 'ec2api', group: 'ec2api')
      end

      it 'does not run migrations when openstack/image/db/migrate is false' do
        node.set['openstack']['db']['ec2api']['migrate'] = false
        expect(chef_run).not_to run_execute(cmd)
      end
    end
  end
end
