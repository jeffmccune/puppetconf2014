# == Class: site::packages
#
# This class manages packages on all managed nodes.
#
class site::packages {
  $packages = [ 'git', 'ruby', 'ruby-devel', 'rubygem-bundler', 'make', 'gcc',
                'sqlite', 'sqlite-devel' ]
  package { $packages: ensure => latest }
}
