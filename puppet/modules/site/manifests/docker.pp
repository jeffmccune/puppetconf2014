# == Class: site::docker
#
# This class manages a minimal CentOS 7 docker host.
#
class site::docker {
  Package { ensure => present }

  package { docker: }
  ~> service { docker:
    ensure => running,
    enable => true,
  }

  user { vagrant:
    groups  => [docker],
    require => Package[docker],
  }
}
