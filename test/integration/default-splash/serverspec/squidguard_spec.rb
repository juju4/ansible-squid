require 'serverspec'

# Required by serverspec
set :backend, :exec

proxy_port = 3128

describe package('squidGuard'), :if => os[:family] == 'redhat' && os[:release] == '6' do
  it { should be_installed }
end

describe service('squidGuard'), :if => os[:family] == 'redhat' && os[:release] == '6' do
  it { should be_enabled }
  it { should be_running }
end  

describe file('/usr/sbin/squidGuard'), :if => os[:family] == 'redhat' && os[:release] == '6' do
  it { should be_executable }
end
