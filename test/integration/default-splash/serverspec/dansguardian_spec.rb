require 'serverspec'

# Required by serverspec
set :backend, :exec

proxy_port = 8080

describe package('dansguardian'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_installed }
end

describe service('dansguardian'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_enabled }
  it { should be_running }
end  

describe file('/usr/sbin/dansguardian'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_executable }
end

describe port(proxy_port), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_listening }
end
