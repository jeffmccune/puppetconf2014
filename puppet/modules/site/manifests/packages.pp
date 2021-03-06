# == Class: site::packages
#
# This class manages packages on all managed nodes.
#
class site::packages {
  $packages = [ 'git', 'ruby', 'ruby-devel', 'rubygem-bundler', 'rubygem-rdoc',
                'rubygem-rake', 'make', 'gcc', 'sqlite', 'sqlite-devel',
                'telnet' ]
  package { $packages: ensure => latest }
}
