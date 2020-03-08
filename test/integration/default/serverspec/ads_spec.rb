require 'serverspec'

# Required by serverspec
set :backend, :exec

if (os[:family] == 'ubuntu' && os[:release] == '19.10')
  set denied_banner = 'E2Guardian - Access Denied'
  proxy_port = 8080
else
  set denied_banner = '<p><b>Access Denied.<\/b><\/p>'
  proxy_port = 8080
end
if os[:family] == 'redhat'
  set denied_banner = 'Access Denied'
  proxy_port = 3128
end

describe file('/var/spool/squid/ad_block.txt') do
  its(:content) { should match /adblockanalytics.com/ }
end

describe file('/etc/squid/squid.conf') do
  its(:content) { should match /acl ads dstdom_regex "\/var\/spool\/squid\/ad_block.txt"/ }
end

describe command("curl -x http://localhost:#{proxy_port} http://www.adblockanalytics.com") do
  its(:stdout) { should match /#{denied_banner}/ }
  its(:exit_status) { should eq 0 }
end
