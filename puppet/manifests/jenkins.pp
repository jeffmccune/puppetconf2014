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

  include jenkins_service_override

  # Packages, e.g. git and such
  class { 'site::packages': }

  # Jenkins
  class { 'site::jenkins':
    ldap_server => 'ldap://ldap',
    rootdn      => $ldap_suffix,
    message     => 'jeffmccune.net Jenkins Container',
  }
}

class jenkins_service_override inherits jenkins::service {
  Service[jenkins] {
    ensure => undef,
    enable => undef,
    status => '/bin/true',
    start  => '/bin/true',
    stop   => '/bin/true',
  }
}
