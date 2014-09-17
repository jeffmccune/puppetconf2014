# == Class: site::packages
#
# This class manages packages on all managed nodes.
#
class site::packages {
  $packages = [ 'git' ]
  package { $packages: ensure => latest }
}
