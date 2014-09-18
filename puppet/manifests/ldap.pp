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

  $ldap_suffix = 'dc=jeffmccune,dc=net'

  # Configure LDAP server
  # rootpw is Password1, generated using openldap_password('Password1')
  class { 'openldap::server':
    suffix    => $ldap_suffix,
    databases => {
      "$ldap_suffix" => {
        directory => '/var/lib/ldap',
        rootdn    => "cn=admin,$ldap_suffix",
        rootpw    => '{SSHA}saqSZkTVjEm7brfmTNj7YpgKWWXHerYh',
      }
    }
  }

  class { 'openldap::client':
    base    => $ldap_suffix,
    uri     => ["ldap://${::fqdn}"],
    require => Class['openldap::server'],
  }

  # Data load
  class { 'site::openldap':
    require => Class['openldap::client'],
  }
}
