# VM that has both LDAP and Jenkins configured
# with Puppet
node sharedvm {
  file { '/identity.json':
    ensure  => file,
    content => "{description: 'Shared VM with LDAP and Jenkins'}\n",
    owner   => 0,
    group   => 0,
    mode    => 0644,
  }

}
