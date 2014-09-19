# See app_lxc/systemd/Dockerfile for the base image
FROM centos7vps
MAINTAINER Jeff McCune <jeff@puppetlabs.com>

# Run Puppet to configure the LDAP service
RUN git clone --branch docker https://github.com/jeffmccune/puppetconf2014 /project
RUN puppet apply -v --node_name_value=ldap --modulepath=/project/puppet/modules /project/puppet/manifests/ldap.pp

EXPOSE 389

# start systemd:
CMD ["/usr/sbin/init"]
