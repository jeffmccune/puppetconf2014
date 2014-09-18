# VM that has both LDAP and Jenkins configured
# with Puppet
node containerhost {
  Package {
    allow_virtual => true,
  }

  file { '/identity.json':
    ensure  => file,
    content => "{description: 'Container host'}\n",
    owner   => 0,
    group   => 0,
    mode    => 0644,
  }

  class { site::packages: }
  -> class { site::docker: }
}
