# See app_lxc/systemd/Dockerfile for the base image
FROM centos7vps
MAINTAINER Jeff McCune <jeff@puppetlabs.com>

# Puppet configuration code
ADD puppet.tar.gz /

# Run Puppet to configure the LDAP service
RUN puppet apply -v --node_name_value=jenkins --modulepath=/puppet/modules /puppet/manifests/jenkins.pp

EXPOSE 8080

# start systemd:
CMD ["/usr/sbin/init"]
