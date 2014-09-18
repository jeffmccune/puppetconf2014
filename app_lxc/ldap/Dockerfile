FROM centos:centos7
MAINTAINER Jeff McCune <jeff@puppetlabs.com>

# install main packages:
RUN yum -y update
RUN yum -y install epel-release

# Install puppet and dependencies
RUN yum -y install http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
RUN yum -y install puppet git hostname

# Add puppet configuration
RUN mkdir -p /config
RUN git clone --branch docker https://github.com/jeffmccune/puppetconf2014 /config
# Run Puppet to configure the LDAP service
RUN puppet apply -v --node_name_value=ldap --modulepath=/config/puppet/modules --manifest=/config/puppet/manifests/ldap.pp

# start services:
CMD ["/bin/bash"]
