require 'serverspec'

# Required by serverspec
set :backend, :exec

describe service('squid3'), :if => os[:family] == 'ubuntu' do  
  it { should be_enabled   }
  it { should be_running   }
end  

describe file('/usr/sbin/squid3'), :if => os[:family] == 'ubuntu' do
  it { should be_executable }
end

describe service('squid'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe file('/usr/sbin/squid'), :if => os[:family] == 'redhat' do
  it { should be_executable }
end

