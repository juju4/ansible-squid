require 'serverspec'

# Required by serverspec
set :backend, :exec

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

describe port(8080), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_listening }
end

describe command('curl -x http://localhost:8080 http://www.google.com'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /302 Moved/ }
  its(:exit_status) { should eq 0 }
end
describe command('curl -x http://localhost:8080 http://www.cnn.com'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /<!DOCTYPE html><html class="no-js"><head>/ }
  its(:exit_status) { should eq 0 }
end
describe command('curl -x http://localhost:8080 http://www.badboys.com'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /<title>DansGuardian - Access Denied<\/title>/ }
  its(:exit_status) { should eq 0 }
end

describe file('/var/run/clamav/clamd.ctl'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_socket }
end
describe command('curl -x http://localhost:8080 http://www.eicar.org/download/eicar.com.txt'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /<title>DansGuardian - Access Denied<\/title>/ }
  its(:stdout) { should match /<b>Virus or bad content detected. Eicar-Test-Signature<\/b>/ }
  its(:exit_status) { should eq 0 }
end

