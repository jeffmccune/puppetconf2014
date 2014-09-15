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

