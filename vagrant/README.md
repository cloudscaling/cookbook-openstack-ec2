To run this cookbook in openstack-chef-repo (https://github.com/openstack/openstack-chef-repo)

0. Do initial setup steps for openstack-chef-repo instruction.

Before rake deploy commands:

1. Add folder openstack-ec2api to the chef-repo cookbooks (openstack-chef-repo/cookbooks/)

2. Add .json files to the roles directory (/openstack-chef-repo/roles/) 

3. Add to the openstack-chef-repo/roles/os-compute-single-controller.json
    "role[os-ec2api]" to the run list.

Rake deploy commands (ec2api will implement only with All-in-One (nova-network or Neutron deployments). 

