require 'tempfile'

Puppet::Type.type(:openldap_dbindex).provide(:olc) do

  # TODO: Use ruby bindings (can't find one that support IPC)

  defaultfor :osfamily => :debian, :osfamily => :redhat

  commands :slapcat => 'slapcat', :ldapmodify => 'ldapmodify'

  mk_resource_methods

  def self.instances
    # TODO: restict to bdb and hdb
    i = []
    slapcat(
      '-b',
      'cn=config',
      '-H',
      'ldap:///???(olcDbIndex=*)'
    ).split("\n\n").collect do |paragraph|
      suffix = nil
      attrlist = nil
      indices = nil
      attribute = nil
      paragraph.gsub("\n ", '').split("\n").collect do |line|
        case line
        when /^olcSuffix: /
          suffix = line.split(' ')[1]
        when /^olcDbIndex: /
          attrlist, dummy, indices = line.match(/^olcDbIndex: (\S+)(\s+(.+))?$/).captures
          attrlist.split(',').each { |attribute|
            i << new(
              :name      => "#{attribute} on #{suffix}",
              :ensure    => :present,
              :attribute => attribute,
              :suffix    => suffix,
              :indices   => indices,
            )
          }
        end
      end
    end
    i
  end

  def self.prefetch(resources)
    dbindexes = instances
    resources.keys.each do |name|
      if provider = dbindexes.find{ |access| access.name == name }
        resources[name].provider = provider
      end
    end
  end

  def getDn(suffix)
    slapcat(
      '-b',
      'cn=config',
      '-H',
      "ldap:///???(olcSuffix=#{suffix})"
    ).split("\n").collect do |line|
      if line =~ /^dn: /
        return line.split(' ')[1]
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    t = Tempfile.new('openldap_dbindex')
    t << "dn: #{getDn(resource[:suffix])}\n"
    t << "add: olcDbIndex\n"
    t << "olcDbIndex: #{resource[:attribute]} #{resource[:indices]}\n"
    t.close
    Puppet.debug(IO.read t.path)
    begin
      ldapmodify('-Y', 'EXTERNAL', '-H', 'ldapi:///', '-f', t.path)
    rescue Exception => e
      raise Puppet::Error, "LDIF content:\n#{IO.read t.path}\nError message: #{e.message}"
    end
  end

end
