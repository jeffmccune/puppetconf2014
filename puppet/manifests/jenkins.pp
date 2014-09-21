# Container with jenkins
node jenkins {
  Package {
    allow_virtual => true,
  }

  file { '/identity.json':
    ensure  => file,
    content => "{description: 'Jenkins Service Container'}\n",
    owner   => 0,
    group   => 0,
    mode    => 0644,
  }

  $ldap_suffix = 'dc=jeffmccune,dc=net'

  # Packages, e.g. git and such
  class { 'site::packages': }

  # Jenkins
  class { 'site::jenkins':
    ldap_server => 'ldap://localhost',
    rootdn      => $ldap_suffix,
    message     => 'jeffmccune.net Jenkins Server',
  }
}
