# == Class: site::jenkins
#
# This class manages the jenkins service.
#
class site::jenkins {
  class { ::jenkins: }

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
}
