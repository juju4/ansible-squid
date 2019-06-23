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

describe command("curl -v -x http://localhost:#{proxy_port} http://www.google.com") do
  its(:stdout) { should match /<title>Proxy Splash page<\/title>/ }
  its(:stderr) { should match /HTTP\/1.1 302 Found/ }
  its(:stdout) { should match /Location: http:\/\/localhost\/splash.php?url=http%3A%2F%2Fwww.google.com%2F/ }
  its(:exit_status) { should eq 0 }
end

describe command("curl -vL -x http://localhost:#{proxy_port} http://www.google.com") do
  its(:stdout) { should match /<title>Proxy Splash page<\/title>/ }
  its(:stdout) { should_not match /Invalid URL/ }
  its(:stderr) { should match /HTTP\/1.1 302 Found/ }
  its(:stderr) { should_not match /400 Bad Request/ }
  its(:stdout) { should match /Location: http:\/\/localhost\/splash.php?url=http%3A%2F%2Fwww.google.com%2F/ }
  # redirection loop...
  its(:stderr) { should_not match /Location: http:\/\/localhost\/splash.php?url=http%3A%2F%2Flocalhost%2Fsplash.php%3Furl%3Dhttp%253A%252F%252Fwww.google.com%252F/ }
  its(:exit_status) { should eq 0 }
end

describe command('db_dump /var/lib/squid/session.db') do
  its(:stdout) { should match /type=btree/ }
  its(:stdout) { should match /DATA=END/ }
  its(:exit_status) { should eq 0 }
end

describe command("echo \"GET http://www.google.com HTTP/1.0\" | nc -v 127.0.0.1 #{proxy_port}"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
# static
#  its(:stdout) { should match /HTTP\/1.1 511 Network Authentication Required/ }
#  its(:stdout) { should match /X-Squid-Error: 511:\/etc\/squid\/splash.html 0/ }
# dynamic splash page
#  its(:stdout) { should match /HTTP\/1.1 302 Found/ }
#  its(:stdout) { should match /Location: http:\/\/localhost\/splash.php?url=http%3A%2F%2Fwww.google.com%2F/ }
  its(:stderr) { should match /Connection to 127.0.0.1 #{proxy_port} port \[tcp\/.*\] succeeded!/ }
  its(:exit_status) { should eq 0 }
end
describe command("echo \"GET http://www.google.com HTTP/1.0\" | nc -v 127.0.0.1 #{proxy_port}"), :if => os[:family] == 'redhat' do
  its(:stderr) { should match /Ncat: Connected to 127.0.0.1:#{proxy_port}/ }
  its(:exit_status) { should eq 0 }
end

# 1st call
describe command('echo 10.0.0.1 concurrency=100 | /usr/lib/squid/ext_session_acl -t 15 -b /var/lib/squid/session.db'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /10.0.0.1 ERR message="Welcome"/ }
  its(:exit_status) { should eq 0 }
end
describe command('echo 10.0.0.1 concurrency=100 | /usr/lib64/squid/ext_session_acl -t 15 -b /var/lib/squid/session.db'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /10.0.0.1 ERR message="Welcome"/ }
  its(:exit_status) { should eq 0 }
end
# 2nd call
describe command('echo 10.0.0.1 concurrency=100 | /usr/lib/squid/ext_session_acl -t 15 -b /var/lib/squid/session.db'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /10.0.0.1 OK/ }
  its(:exit_status) { should eq 0 }
end
describe command('echo 10.0.0.1 concurrency=100 | /usr/lib64/squid/ext_session_acl -t 15 -b /var/lib/squid/session.db'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /10.0.0.1 OK/ }
  its(:exit_status) { should eq 0 }
end

describe file('/var/lib/squid/session.db'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_file }
  it { should be_owned_by 'proxy' }
  it { should be_grouped_into 'proxy' }
  it { should be_mode 600 }
end

describe file('/var/lib/squid/session.db'), :if => os[:family] == 'redhat' do
  it { should be_file }
  it { should be_owned_by 'squid' }
  it { should be_grouped_into 'squid' }
  it { should be_mode 600 }
end

describe file('/var/log/squid/cache.log'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_file }
  it { should be_owned_by 'proxy' }
  it { should be_grouped_into 'proxy' }
  it { should be_mode 640 }
  its(:content) { should_not match /| WARNING: splash_page #Hlpr.* exited/ }
  its(:content) { should_not match /FATAL: The splash_page helpers are crashing too rapidly, need help!/ }
end

describe file('/var/log/squid/cache.log'), :if => os[:family] == 'redhat' do
  it { should be_file }
  it { should be_owned_by 'squid' }
  it { should be_grouped_into 'squid' }
  it { should be_mode 640 }
  its(:content) { should_not match /| WARNING: splash_page #Hlpr.* exited/ }
  its(:content) { should_not match /FATAL: The splash_page helpers are crashing too rapidly, need help!/ }
end
