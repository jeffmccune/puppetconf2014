# == Class: site::openldap
#
# This class manages site specific OpenLDAP resources, e.g. access control
# resources.
#
class site::openldap {
  Exec { path => "/usr/bin:/bin:/usr/sbin:/sbin" }
  $schema = '/etc/openldap/schema'
  $ldapsearch = 'ldapsearch -Y EXTERNAL -H ldapi:///'
  $ldapadd = 'ldapadd -D cn=admin,dc=jeffmccune,dc=net -w Password1 -H ldapi:///'

  File {
    owner  => 0,
    group  => 0,
    mode   => 0700,
  }

  # Files
  file { '/etc/openldap/data':
    ensure => directory,
  }
  file { '/etc/openldap/data/site.ldif':
    ensure  => file,
    content => template('site/site.ldif')
  }
  file { '/etc/openldap/data/groups.ldif':
    ensure  => file,
    content => template('site/groups.ldif')
  }
  file { '/etc/openldap/data/users.ldif':
    ensure  => file,
    content => template('site/users.ldif')
  }
  file { '/etc/openldap/data/jeff_group.ldif':
    ensure  => file,
    content => template('site/jeff_group.ldif')
  }
  file { '/etc/openldap/data/jeff_user.ldif':
    ensure  => file,
    content => template('site/jeff_user.ldif')
  }

  # Initial Schema Load, in order
  exec { 'core schema':
    command => "ldapadd -Y EXTERNAL -H ldapi:/// -f ${schema}/core.ldif",
    unless  => "$ldapsearch -b cn=config cn={*}core | grep numEntries"
  }
  -> exec { 'cosine schema':
    command => "ldapadd -Y EXTERNAL -H ldapi:/// -f ${schema}/cosine.ldif",
    unless  => "$ldapsearch -b cn=config cn={*}cosine | grep numEntries"
  }
  -> exec { 'inetorgperson schema':
    command => "ldapadd -Y EXTERNAL -H ldapi:/// -f ${schema}/inetorgperson.ldif",
    unless  => "$ldapsearch -b cn=config cn={*}inetorgperson | grep numEntries"
  }
  -> exec { 'nis schema':
    command => "ldapadd -Y EXTERNAL -H ldapi:/// -f ${schema}/nis.ldif",
    unless  => "$ldapsearch -b cn=config cn={*}nis | grep numEntries"
  }
  -> exec { 'dc=jeffmccune,dc=net':
    command => "$ldapadd -f /etc/openldap/data/site.ldif",
    unless  => "$ldapsearch -b dc=jeffmccune,dc=net dc=jeffmccune | grep numEntries"
  }
  -> exec { 'ou=Groups':
    command => "$ldapadd -f /etc/openldap/data/groups.ldif",
    unless  => "$ldapsearch -b dc=jeffmccune,dc=net ou=Groups | grep numEntries"
  }
  -> exec { 'ou=Users':
    command => "$ldapadd -f /etc/openldap/data/users.ldif",
    unless  => "$ldapsearch -b dc=jeffmccune,dc=net ou=Users | grep numEntries"
  }
  -> exec { 'cn=jeff,ou=Groups':
    command => "$ldapadd -f /etc/openldap/data/jeff_group.ldif",
    unless  => "$ldapsearch -b ou=Groups,dc=jeffmccune,dc=net cn=jeff | grep numEntries"
  }
  -> exec { 'uid=jeff,ou=Users':
    command => "$ldapadd -f /etc/openldap/data/jeff_user.ldif",
    unless  => "$ldapsearch -b ou=Users,dc=jeffmccune,dc=net uid=jeff | grep numEntries"
  }
}
