# == Class: site::docker
#
# This class manages a minimal CentOS 7 docker host.
#
class site::docker {
  $module = 'site'

  Package { ensure => present }

  package { docker: }
  ~> service { docker:
    ensure => running,
    enable => true,
  }

  file { '/usr/bin/docker':
    ensure => file,
    source => "puppet:///modules/${module}/docker/bin/docker",
    owner  => 0,
    group  => 0,
    mode   => 755,
  }

  user { vagrant:
    groups  => [docker],
    require => Package[docker],
  }
}
