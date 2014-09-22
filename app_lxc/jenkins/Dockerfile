# See app_lxc/systemd/Dockerfile for the base image
FROM centos7vps
MAINTAINER Jeff McCune <jeff@puppetlabs.com>

# Puppet configuration code
ADD puppet.tar.gz /

# Run Puppet to configure the LDAP service
RUN puppet apply -v --node_name_value=jenkins --modulepath=/puppet/modules /puppet/manifests/jenkins.pp

EXPOSE 8080

ENV JENKINS_HOME /var/lib/jenkins
USER jenkins

# start jenkins:
ENTRYPOINT ["/usr/bin/java", "-DJENKINS_HOME=/var/lib/jenkins", "-jar", "/usr/lib/jenkins/jenkins.war", "--logfile=/var/log/jenkins/jenkins.log", "--webroot=/var/cache/jenkins/war", "--httpPort=8080", "--ajp13Port=8009", "--debug=5", "--handlerCountMax=100", "--handlerCountMaxIdle=20"]
