# VM that has both LDAP and Jenkins configured
# with Puppet
node sharedvm {
  Package {
    allow_virtual => true,
  }

  file { '/identity.json':
    ensure  => file,
    content => "{description: 'Shared VM with LDAP and Jenkins'}\n",
    owner   => 0,
    group   => 0,
    mode    => 0644,
  }

  # Configure LDAP server
  class { 'openldap::server': }
}
