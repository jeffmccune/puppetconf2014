Puppet::Type.newtype(:openldap_dbindex) do
  @doc = 'Manages OpenLDAP DB indexes'

  ensurable

  newparam(:name) do
    desc "The default namevar"
  end

  newparam(:target) do
    desc "The slapd.conf file"
  end

  newparam(:suffix, :namevar => true) do
    desc "The suffix to which the index applies"
  end

  newparam(:attribute) do
    desc "The attribute to index"
    defaultto('default')
  end

  def self.title_patterns
    [
      [
        /^((\S+)\s+on\s+(.+))$/,
        [
          [ :name, lambda{|x| x} ],
          [ :attribute, lambda{|x| x} ],
          [ :suffix, lambda{|x| x} ],
        ],
      ],
      [
        /(.*)/,
        [
          [ :name, lambda{|x| x} ],
        ],
      ],
    ]
  end

  newproperty(:indices) do
    desc "The indices to maintain"
  end

  autorequire(:openldap_database) do
    [ value(:suffix) ]
  end

end
