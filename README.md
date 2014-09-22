# PuppetConf 2014

## How Puppet Enables the Use of Lightweight Virtualized Containers

In this talk you'll learn about three common scenarios where Puppet amplifies
the power and flexibility of new and existing virtualization technologies.
First, traditional virtualization techniques such as VMware and Xen provide
repeatability and consistency through golden images. Puppet helps minimize the
sprawling nature of these images and provides management through their entire
lifecycle.

Second, with new virtualization technologies such as Linux containers, the
golden image problem has been greatly improved with tools like Docker. In this
new scenario, Puppet provides the ability to audit and report on the state of
the running container over the entire lifecycle.

Finally, Puppet provides an extremely powerful language and collection of
existing modules to easily migrate from "heavy" virtual machines to the new
lightweight containers. Come see how Forge modules deploy the same software
stack into both traditional VMs and lightweight containers, quickly and easily.

# Demo

The demo is focused on using Puppet modules to configure an LDAP service and a
Jenkins service, bound to LDAP.  These same modules allow the services to be
configured both in traditional VMware virtual machines and inside of
lightweight virtualized containers.

To get started with the VMware VM's:

    cd app_vms
    vagrant up

To get started with the lightweight containers:

    cd app_lxc
    vagrant up

# Docker Containers

Once the `app_lxc` vagrant image is running, the docker images may be built and
then run.  The LDAP container should be built first and the jenkins container
connected to a running ldap container for authentication.

Build the systemd enabled centos base image as a pre-requisite to the other
containers.  This enables systemd as an option when running containers, however
systemd is not operating during the `docker build` phase and as such `service`
resources in Puppet still need to be overridden for the puppet run to complete
successfully during the build phase.  The build process will produce the
`centos7vps` base image.

    cd app_lxc
    vagrant ssh
    cd /vagrant/systemd
    rake build

Build and run the ldap container.  It is "lite" because it runs without systemd
or any other processes, only `slapd`.  The build process will produce the
`ldap_lite` base image.

    cd app_lxc
    vagrant ssh
    cd /vagrant/ldap_lite
    rake build
    rake run

At this point there will be a running LDAP service, configured by Puppet:

    docker ps
    CONTAINER ID        IMAGE               COMMAND                CREATED         STATUS         PORTS    NAMES
    058bcb050aa9        ldap_lite:latest    "/usr/sbin/slapd -u    20 minutes ago  Up 20 minutes  389/tcp  ldap

Next, build the jenkins container.  The build process will produce the
`jenkins:lite` base image.  The run process needs to run after the ldap
container is running because jenkins requires ldap for authentication.

    cd app_lxc
    cd /vagrant/ldap_lite
    rake build
    rake run

At this point there will be a running Jenkins service connected to the LDAP
container for authentication.

    docker ps
    CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                    NAMES
    cc8845a2cc73        jenkins:lite        "/usr/bin/java -DJEN   25 minutes ago      Up 25 minutes       0.0.0.0:8080->8080/tcp   jenkins
    058bcb050aa9        ldap_lite:latest    "/usr/sbin/slapd -u    26 minutes ago      Up 26 minutes       389/tcp                  jenkins/ldap,ldap

EOF
