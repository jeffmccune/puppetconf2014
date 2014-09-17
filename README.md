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

# LDAP Load

Once the VM is created from scratch, load the data in the following order.
Note, this initial data load happens automatically when the `site::openldap`
class is included in the configuration catalog.

    schema=/etc/openldap/schema
    sudo ldapadd -Y EXTERNAL -H ldapi:/// -f $schema/core.ldif
    sudo ldapadd -Y EXTERNAL -H ldapi:/// -f $schema/cosine.ldi
    sudo ldapadd -Y EXTERNAL -H ldapi:/// -f $schema/inetorgperson.ldif
    sudo ldapadd -Y EXTERNAL -H ldapi:/// -f $schema/nis.ldif

With the schema loaded, add the root site:

    $ ldapadd -D cn=admin,dc=jeffmccune,dc=net -w Password1 -H ldapi:/// \
      -f /tmp/vagrant-puppet-2/modules-0/site/templates/site.ldif
    adding new entry "dc=jeffmccune,dc=net"

And verify with ldap search.  You should not get a `32 No such object`
response, which indicates there is no root object.

    $ ldapsearch -Y EXTERNAL -H ldapi:///
    SASL/EXTERNAL authentication started
    SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
    SASL SSF: 0
    # extended LDIF
    #
    # LDAPv3
    # base <dc=jeffmccune,dc=net> (default) with scope subtree
    # filter: (objectclass=*)
    # requesting: ALL
    #
    # jeffmccune.net
    dn: dc=jeffmccune,dc=net
    objectClass: dcObject
    objectClass: organization
    dc: jeffmccune
    o: jeffmccune
    # search result
    search: 2
    result: 0 Success
    # numResponses: 2
    # numEntries: 1

Now load the rest of the structure:

    $ ldapadd -D cn=admin,dc=jeffmccune,dc=net -w Password1 -H ldapi:/// -f groups.ldif
    adding new entry "ou=Groups,dc=jeffmccune,dc=net"
    $ ldapadd -D cn=admin,dc=jeffmccune,dc=net -w Password1 -H ldapi:/// -f users.ldif
    adding new entry "ou=Users,dc=jeffmccune,dc=net"

Now load the accounts themselves:

    ldapadd -D cn=admin,dc=jeffmccune,dc=net -w Password1 -H ldapi:/// -f jeff_group.ldif
    adding new entry "cn=jeff,ou=groups,dc=jeffmccune,dc=net"
    ldapadd -D cn=admin,dc=jeffmccune,dc=net -w Password1 -H ldapi:/// -f jeff_user.ldif
    adding new entry "uid=jeff,ou=users,dc=jeffmccune,dc=net"
