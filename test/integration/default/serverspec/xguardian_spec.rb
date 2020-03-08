require 'serverspec'

# Required by serverspec
set :backend, :exec

if (os[:family] == 'ubuntu' && os[:release] == '19.10')
  set guardian_pkg = 'e2guardian'
  set denied_banner = 'E2Guardian - Access Denied'
else
  set guardian_pkg = 'dansguardian'
  set denied_banner = 'DansGuardian - Access Denied'
end
proxy_port = 8080

if (os[:family] == 'ubuntu' || os[:family] == 'debian')
  describe package(guardian_pkg) do
    it { should be_installed }
  end

  describe service(guardian_pkg) do
    it { should be_enabled }
    it { should be_running }
  end

  describe file("/usr/sbin/#{guardian_pkg}") do
    it { should be_executable }
  end

  describe port(proxy_port) do
    it { should be_listening }
  end

  describe command("curl -v -x http://localhost:#{proxy_port} http://www.google.com") do
    its(:stdout) { should match /<title>Google<\/title>/ }
    its(:stderr) { should match /HTTP\/1.1 200 OK/ }
    its(:exit_status) { should eq 0 }
  end
  describe command("curl -v -x http://localhost:#{proxy_port} http://www.cnn.com") do
    its(:stderr) { should match /HTTP\/1.1 301 Moved Permanently/ }
    its(:exit_status) { should eq 0 }
  end
  describe command("curl -v -x http://localhost:#{proxy_port} http://www.badboys.com") do
    its(:stdout) { should match /#{denied_banner}/ }
    its(:exit_status) { should eq 0 }
  end

  describe file("/var/log/#{guardian_pkg}/access.log") do
    its(:content) { should match /http:\/\/www.badboys.com.*\*DENIED\*/ }
  end
end
