require 'serverspec'

# Required by serverspec
set :backend, :exec

if os[:family] == 'ubuntu' || os[:family] == 'debian'
  proxy_port = 8080
end
if os[:family] == 'redhat'
  proxy_port = 3128
end

describe command("curl -x http://localhost:#{proxy_port} http://www.adblockanalytics.com") do
  its(:stdout) { should match /<p><b>Access Denied.<\/b><\/p>/ }
#  its(:stdout) { should match /<title>DansGuardian - Access Denied<\/title>/ }
#  its(:stdout) { should_not match /\(squid\/[0-9.]+\)<\/p>/ }
  its(:exit_status) { should eq 0 }
end

