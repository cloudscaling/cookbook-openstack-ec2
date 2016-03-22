# Encoding: utf-8
#
# Cookbook Name:: openstack-ec2api
# Spec:: metadata_spec
#
# Copyright 2016, EMC Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative 'spec_helper'

describe 'openstack-ec2api::metadata' do
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    include_context 'ec2-api-stubs'

    it 'includes ec2api common recipe' do
      expect(chef_run).to include_recipe('openstack-ec2api::common')
    end

    describe 'ec2-api-metadata.conf' do
      let(:file) { chef_run.template('/etc/init/ec2-api-metadata.conf') }

      it 'should create the /etc/init/ec2-api-metadata.conf file' do
        expect(chef_run).to create_template(file.name)
      end

      it 'notifies ec2-api-metadata restart' do
        expect(file).to notify('service[ec2-api-metadata]').to(:start)
      end

      it 'starts ec2-api-metadata on boot' do
        expect(chef_run).to enable_service 'ec2-api-metadata'
      end
    end
  end
end
