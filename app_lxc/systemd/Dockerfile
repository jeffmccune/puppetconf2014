FROM centos:centos7
MAINTAINER Jeff McCune <jeff@puppetlabs.com>
ENV container docker
RUN yum -y update; yum clean all

## Install systemd into the container and disable nearly everything except:
# /usr/sbin/init, systemd-journald, systemd-logind, dbus-daemon
#
# https://bugzilla.redhat.com/show_bug.cgi?id=1118740
# http://developerblog.redhat.com/2014/05/05/running-systemd-within-docker-container/
RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs; yum clean all;\
find /lib/systemd/system/sysinit.target.wants -mindepth 1 -not -name systemd-tmpfiles-setup.service -print0 | xargs -0 rm -f;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME ["/sys/fs/cgroup"]

# Install puppet and dependencies
RUN yum -y install http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm; yum clean all
RUN yum -y install puppet git hostname; yum clean all
# Work around puppet warning about missing hiera.yaml file
RUN touch /etc/puppet/hiera.yaml

# Cache the base packages managed by puppet
RUN yum -y install git ruby make ruby-devel rubygem-rake rubygem-bundler rubygem-rdoc gcc sqlite sqlite-devel telnet; yum clean all
RUN yum -y install java wget; yum clean all

# start services:
CMD ["/usr/sbin/init"]
