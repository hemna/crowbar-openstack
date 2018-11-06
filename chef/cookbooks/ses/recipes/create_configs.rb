#
# Cookbook Name:: create_configs
# Recipe:: crowbar
#
# Copyright 2018, SUSE Linux GmbH
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


# This recipe creates the /etc/ceph/ceph.conf
# and the keyring files needed by the services
Chef::Log.info("SES: create_configs started")



Chef::Log.info("SES: create_configs done")

ceph_conf  = search(:node, "ses:ceph_conf") || []
Chef::Log.info("SES: ceph_conf = #{ceph_conf}")

Chef::Log.info("SES config Try and load it!")
ses_config = BarclampLibrary::Barclamp::Config.load(
  "openstack",
  "ses"
)
Chef::Log.info("SES config = #{ses_config}")
Chef::Log.info("node = #{node}")
# This is an external ceph cluster, it could be SES
if !node[:ses].nil? && !node[:ses].empty?
  Chef::Log.info("Ceph is configred external and we found a SES proposal.")
  Chef::Log.info("SES create ceph.conf")
  # SES is enabled, lets create the ceph.conf
  template "/etc/ceph/ceph.conf" do
    source "ceph.conf.erb"
    owner "cinder"
    group "root"
    mode "0644"
    variables(service_name: cinder_volume_service)
  end

  # Now create the cinder user keyring file
  Chef::Log.info("SES create cinder keyring ceph.client.#{ses_cinder_client}.keyring")
  ses_cinder_client = node[:ses][:cinder][:rbd_store_user]
  template "/etc/ceph/ceph.client.#{ses_cinder_client}.keyring" do
    source "client.keyring.erb"
    owner "cinder"
    group "root"
    mode "0644"
    variables(client_name: ses_cinder_client,
              keyring_value: node[:ses][:cinder][:key])
  end
end
