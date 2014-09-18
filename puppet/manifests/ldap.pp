# VM that has both LDAP and Jenkins configured
# with Puppet
node ldap {
  Package {
    allow_virtual => true,
  }

  file { '/identity.json':
    ensure  => file,
    content => "{description: 'LDAP Container'}\n",
    owner   => 0,
    group   => 0,
    mode    => 0644,
  }

  class { site::packages: }
}
