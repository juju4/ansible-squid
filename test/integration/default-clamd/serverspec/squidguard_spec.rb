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

describe command("curl -v -x http://localhost:#{proxy_port} http://www.google.com"), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /<title>Google<\/title>/ }
  its(:stderr) { should match /HTTP\/1.1 200 OK/ }
  its(:exit_status) { should eq 0 }
end
describe command("curl -v -x http://localhost:#{proxy_port} http://www.cnn.com"), :if => os[:family] == 'redhat' do
  its(:stderr) { should match /HTTP\/1.1 301 Moved Permanently/ }
  its(:exit_status) { should eq 0 }
end

describe command("curl -x http://localhost:#{proxy_port} http://www.eicar.org/download/eicar.com.txt"), :if => os[:family] == 'redhat' && os[:release] == '6' do
  its(:stdout) { should match /<b>Virus or bad content detected. Eicar-Test-Signature<\/b>/ }
  its(:exit_status) { should eq 0 }
end

