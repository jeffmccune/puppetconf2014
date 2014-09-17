# == Class: site::jenkins
#
# This class manages the jenkins service.
#
# === Parameters
#
# Document parameters here.
#
# [*ldap_server*]
#   Configure LDAP servers using an Array of URI's.  e.g. ['ldap://localhost']
#
# [*rootdn*]
#   Configure the LDAP root DN used for LDAP queries
#
# [*message*]
#   Configure the Jenkins System Message
#
class site::jenkins(
  $ldap_server,
  $rootdn,
  $message = 'Jenkins Server',
) {
  $jenkins_home = '/var/lib/jenkins'

  class { ::jenkins: }

  file { "${jenkins_home}/config.xml":
    ensure  => file,
    content => template('site/jenkins/config.xml.erb'),
    replace => false,
    owner   => jenkins,
    group   => jenkins,
    mode    => 0644,
    notify  => Service[jenkins],
  }

  jenkins::plugin { credentials:
    version => '1.15',
    before  => Jenkins::Plugin[git],
  }
  jenkins::plugin { 'scm-api':
    version => '0.2',
    before  => Jenkins::Plugin[git],
  }
  jenkins::plugin { 'token-macro':
    version => '1.10',
    before  => Jenkins::Plugin[git],
  }
  jenkins::plugin { 'parameterized-trigger':
    version => '2.4',
    before  => Jenkins::Plugin[git],
  }
  jenkins::plugin { 'git-client':
    version => '1.10.1',
    before  => Jenkins::Plugin[git],
  }
  jenkins::plugin { 'ssh-credentials':
    version => '1.7.1',
    before  => Jenkins::Plugin[git],
  }
  jenkins::plugin { git:
    version => '2.2.5',
  }
  jenkins::plugin { ldap:
    version => '1.10.2'
  }
}
