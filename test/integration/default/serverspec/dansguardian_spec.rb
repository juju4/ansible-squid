require 'serverspec'

# Required by serverspec
set :backend, :exec

proxy_port = 3128

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

describe command("curl -v -x http://localhost:#{proxy_port} http://www.google.com"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /<title>Google<\/title>/ }
  its(:stderr) { should match /HTTP\/1.1 200 OK/ }
  its(:exit_status) { should eq 0 }
end
describe command("curl -v -x http://localhost:#{proxy_port} http://www.cnn.com"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stderr) { should match /HTTP\/1.1 301 Moved Permanently/ }
  its(:exit_status) { should eq 0 }
end
describe command("curl -v -x http://localhost:#{proxy_port} http://www.badboys.com"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /<title>DansGuardian - Access Denied<\/title>/ }
  its(:exit_status) { should eq 0 }
end

describe file('/var/run/clamav/clamd.ctl'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_socket }
end
describe command("curl -v -x http://localhost:#{proxy_port} http://www.eicar.org/download/eicar.com.txt"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /<title>DansGuardian - Access Denied<\/title>/ }
  its(:stdout) { should match /<b>Virus or bad content detected. Eicar-Test-Signature<\/b>/ }
  its(:exit_status) { should eq 0 }
end

