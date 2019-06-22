require 'serverspec'

# Required by serverspec
set :backend, :exec

if os[:family] == 'ubuntu' || os[:family] == 'debian'
  proxy_port = 8080
end
if os[:family] == 'redhat'
  proxy_port = 3128
end

describe file('/etc/squid/ad_block.txt') do
  its(:content) { should match /adblockanalytics.com/ }
end

describe file('/etc/squid/squid.conf') do
  its(:content) { should match /acl ads dstdom_regex "\/etc\/squid\/ad_block.txt"/ }
end

