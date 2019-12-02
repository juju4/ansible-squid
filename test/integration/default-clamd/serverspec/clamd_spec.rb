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

describe file('/var/log/clamav/freshclam.log'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:content) { should match /ClamAV update process started at/ }
  its(:content) { should_not match /Can't query / }
  its(:content) { should_not match /ERROR:/ }
end
describe file('/var/log/clamav/clamav.log'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:content) { should match /LOCAL: Unix socket file \/tmp\/clamd.ctl/ }
  its(:content) { should match /Eicar-Test-Signature\(/ }
  its(:content) { should_not match /ERROR:/ }
end
