require 'serverspec'

# Required by serverspec
set :backend, :exec

describe package('clamav-daemon'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_installed }
end

describe service('clamav-daemon'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_enabled }
  it { should be_running }
end  

describe process("freshclam"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:user) { should eq "clamav" }
#  its(:args) { should match /-d --foreground=true/ }
end

describe process("clamd"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:user) { should eq "proxy" }
#  its(:args) { should match /--foreground=true/ }
end

describe file('/etc/clamav/clamd.conf'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_readable }
end
describe file('/etc/clamav/freshclam.conf'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_readable }
end

describe file('/tmp/clamd.ctl'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_socket }
end

