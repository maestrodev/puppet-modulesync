# This file is managed centrally by modulesync
#   https://github.com/maestrodev/puppet-modulesync

require 'puppetlabs_spec_helper/module_spec_helper'
<% (@configs['requires'] || []).each do |r| -%>
require '<%= r %>'
<% end -%>

RSpec.configure do |c|
  c.mock_with :rspec
  c.hiera_config = File.expand_path(File.join(__FILE__, '../fixtures/hiera.yaml'))

  c.before(:each) do
    Puppet::Util::Log.level = :warning
    Puppet::Util::Log.newdestination(:console)
  end

  c.default_facts = {
    :operatingsystem => 'CentOS',
    :operatingsystemrelease => '6.6',
    :kernel => 'Linux',
    :osfamily => 'RedHat',
    :architecture => 'x86_64',
    :clientcert => 'puppet.acme.com'
  }.merge(<%= @configs['default_facts'] || {} -%>)

  c.before do
    # avoid "Only root can execute commands as other users"
    Puppet.features.stubs(:root? => true)
  end
end

shared_examples :compile, :compile => true do
  it { should compile.with_all_deps }
end

<%= "\n" + @configs['extra_code'] if @configs['extra_code'] -%>
