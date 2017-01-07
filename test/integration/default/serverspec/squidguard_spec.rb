require 'serverspec'

# Required by serverspec
set :backend, :exec

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

describe command('curl -x http://localhost:3128 http://www.google.com'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /302 Moved/ }
  its(:exit_status) { should eq 0 }
end
describe command('curl -x http://localhost:3128 http://www.cnn.com'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /<!DOCTYPE html><html class="no-js"><head>/ }
  its(:exit_status) { should eq 0 }
end
describe command('curl -x http://localhost:3128 http://www.badboys.com'), :if => os[:family] == 'redhat' && os[:release] == '6' do
  its(:stdout) { should match /<title>DansGuardian - Access Denied<\/title>/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl -x http://localhost:3128 http://www.eicar.org/download/eicar.com.txt'), :if => os[:family] == 'redhat' && os[:release] == '6' do
  its(:stdout) { should match /<title>DansGuardian - Access Denied<\/title>/ }
  its(:stdout) { should match /<b>Virus or bad content detected. Eicar-Test-Signature<\/b>/ }
  its(:exit_status) { should eq 0 }
end

