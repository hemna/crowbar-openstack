name "glance"
maintainer "Crowbar project"
maintainer_email "crowbar@googlegroups.com"
license "Apache 2.0"
description "Installs/Configures Glance"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version "0.2"
depends "keystone"
depends "memcached"
depends "database"
depends "ceph"
depends "crowbar-openstack"
depends "crowbar-pacemaker"
depends "utils"
depends "ses"
