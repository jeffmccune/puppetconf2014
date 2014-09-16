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
}
