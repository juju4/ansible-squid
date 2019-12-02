require 'serverspec'

# Required by serverspec
set :backend, :exec

describe package('squid') do
  it { should be_installed }
end

describe service('squid') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/usr/sbin/squid') do
  it { should be_executable }
end

describe port(3128) do
  it { should be_listening }
end

proxy_port = 3128

describe command("curl -v -x http://localhost:#{proxy_port} http://www.google.com"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /<title>Google<\/title>/ }
  its(:stderr) { should match /HTTP\/1.1 200 OK/ }
  its(:exit_status) { should eq 0 }
end
describe command("curl -v -x http://localhost:#{proxy_port} http://www.cnn.com"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stderr) { should match /HTTP\/1.1 301 Moved Permanently/ }
  its(:exit_status) { should eq 0 }
end
# block is at dansguardian level (port 8080)
describe command("curl -v -x http://localhost:#{proxy_port} http://www.badboys.com"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stderr) { should match /HTTP\/1.1 200 OK/ }
  its(:exit_status) { should eq 0 }
end

describe command("curl -v -x http://localhost:#{proxy_port} http://www.eicar.org/download/eicar.com.txt"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should include "EICAR-STANDARD-ANTIVIRUS-TEST-FILE!" }
  its(:exit_status) { should eq 0 }
end

describe file('/var/log/squid/cache.log') do
  its(:content) { should match /Starting Squid Cache version / }
  its(:content) { should match /Accepting HTTP Socket connections at/ }
  its(:content) { should match /Completed Validation Procedure/ }
  its(:content) { should_not match /WARNING/ }
end
