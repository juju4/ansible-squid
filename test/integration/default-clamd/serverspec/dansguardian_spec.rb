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

describe command("curl -v -x http://localhost:#{proxy_port} http://malware.wicar.org/data/eicar.com"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /<title>DansGuardian - Access Denied<\/title>/ }
  #its(:stdout) { should match /<b>Virus or bad content detected. Win.Test.EICAR_HDB-1<\/b>/ }
  its(:stdout) { should match /<b>Banned extension: .com<\/b>/ }
  its(:exit_status) { should eq 0 }
end

describe command("curl -v -x http://localhost:#{proxy_port} http://malware.wicar.org/data/ms03_020_ie_objecttype.html"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /<title>DansGuardian - Access Denied<\/title>/ }
  its(:stdout) { should match /<b>Virus or bad content detected. Html.Exploit.ObjectType-2<\/b>/ }
  its(:exit_status) { should eq 0 }
end
describe file('/etc/dansguardian/dansguardian.conf'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:content) { should match /^contentscanner = '\/etc\/dansguardian\/contentscanners\/clamdscan.conf'/ }
end

describe file('/var/log/dansguardian/access.log'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:content) { should match /http:\/\/www.google.com \*SCANNED\*/ }
  its(:content) { should match /http:\/\/www.badboys.com \*DENIED\* Banned site:/ }
  #its(:content) { should match /http:\/\/malware.wicar.org\/data\/eicar.com \*INFECTED\* \*DENIED\* Virus or bad content detected. Win.Test.EICAR_HDB-1/ }
  its(:content) { should match /http:\/\/malware.wicar.org\/data\/eicar.com \*DENIED\* Banned extension: \.com/ }
  its(:content) { should match /http:\/\/malware.wicar.org\/data\/ms03_020_ie_objecttype.html \*INFECTED\* \*DENIED\* Virus or bad content detected. Html.Exploit.ObjectType-2/ }
end
describe file('/var/log/clamav/clamav.log'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  #its(:content) { should match /Win.Test.EICAR_HDB-1/ }
  its(:content) { should match /Html.Exploit.ObjectType-2.* FOUND/ }
end
