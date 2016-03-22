# Encoding: utf-8
#
# Cookbook Name:: openstack-ec2api
# Spec:: user_spec
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

describe 'openstack-ec2api::user' do
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    include_context 'ec2-api-stubs'

    describe 'user creation' do
      it 'creates group' do
        expect(chef_run).to create_group('ec2api')
      end

      it 'creates user' do
        expect(chef_run).to create_user('ec2api').with(
          group: 'ec2api',
          system: true,
          shell: '/bin/bash'
      )
      end
    end
  end
end
