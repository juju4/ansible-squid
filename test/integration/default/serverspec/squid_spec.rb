require 'serverspec'

# Required by serverspec
set :backend, :exec

describe package('squid') do
  it { should be_installed }
end

describe service('squid3'), :if => os[:family] == 'ubuntu' && os[:release] != '16.04' do
  it { should be_enabled }
  it { should be_running }
end  

describe file('/usr/sbin/squid3'), :if => os[:family] == 'ubuntu' do
  it { should be_executable }
end

describe service('squid'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end
describe service('squid'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
  it { should be_enabled }
  it { should be_running }
end

describe file('/usr/sbin/squid'), :if => os[:family] == 'redhat' do
  it { should be_executable }
end

describe port(3128) do
  it { should be_listening }
end

