require 'serverspec'

# Required by serverspec
set :backend, :exec

proxy_port = 3128

describe command("curl -v -x http://localhost:#{proxy_port} https://www.google.com"), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /<title>Google<\/title>/ }
  its(:stderr) { should match /HTTP\/1.1 200 OK/ }
  its(:exit_status) { should eq 0 }
end
describe command("curl -v -x http://localhost:#{proxy_port} https://www.google.com"), :if => os[:family] == 'ubuntu' do
  its(:stdout) { should match /<title>Google<\/title>/ }
  its(:stderr) { should match /HTTP\/1.1 200 Connection established/ }
  its(:stderr) { should match /CONNECT phase completed!/ }
  its(:stderr) { should match /SSL connection using TLSv1.3 \/ TLS_AES_256_GCM_SHA384/ }
  its(:stderr) { should match /Using HTTP2, server supports multi-use/ }
  its(:stderr) { should match /Connection state changed \(HTTP\/2 confirmed\)/ }
  its(:stderr) { should match /GET \/ HTTP\/2/ }
  its(:stderr) { should match /\(IN\), TLS Unknown, Unknown \(23\):/ }
  its(:stderr) { should match /\(OUT\), TLS Unknown, Unknown \(23\):/ }
  its(:exit_status) { should eq 0 }
end

describe command("curl -kvL -x http://localhost:#{proxy_port} https://www.cnn.com"), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /<!DOCTYPE html><html class="no-js"><head>/ }
  its(:stderr) { should match /HTTP\/1.1 200 OK/ }
  its(:exit_status) { should eq 0 }
end
describe command("curl -kvL -x http://localhost:#{proxy_port} https://www.cnn.com"), :if => os[:family] == 'ubuntu' do
  its(:stdout) { should match /<!DOCTYPE html><html class="no-js"><head>/ }
  its(:stderr) { should match /HTTP\/1.1 200 Connection established/ }
  its(:stderr) { should match /CONNECT phase completed!/ }
  its(:stderr) { should match /TLSv1.2 \(IN\)/ }
  its(:stderr) { should match /TLSv1.2 \(OUT\)/ }
  its(:exit_status) { should eq 0 }
end

# SSL inspection
describe command("curl -v -x http://localhost:#{proxy_port} --cacert /etc/ssl/`hostname`.crt https://www.google.com"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stdout) { should match /<title>Google<\/title>/ }
  its(:stderr) { should match /CONNECT www.google.com:443 HTTP\/1.1/ }
  its(:stderr) { should match /HTTP\/1.1 200 Connection established/ }
  its(:stderr) { should match /CONNECT phase completed!/ }
  its(:stderr) { should match /HTTP\/1.1 200 OK/ }
  its(:stderr) { should match /GET \/ HTTP\/1.1/ }
  its(:stderr) { should_not match /error setting certificate verify locations:/ }
  its(:exit_status) { should eq 0 }
end
describe command("curl -vk -x http://localhost:#{proxy_port} --cacert /etc/ssl/`hostname`.crt https://expired.badssl.com/"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  its(:stderr) { should match /CONNECT expired.badssl.com:443 HTTP\/1.1/ }
  its(:stderr) { should match /HTTP\/1.1 200 Connection established/ }
  its(:stderr) { should match /CONNECT phase completed!/ }
  its(:stderr) { should match /issuer: C=GB; ST=Greater Manchester; L=Salford; O=COMODO CA Limited; CN=COMODO RSA Domain Validation Secure Server CA/ }
  its(:stderr) { should match /GET \/ HTTP\/1.1/ }
  its(:stderr) { should_not match /error setting certificate verify locations:/ }
  its(:stdout) { should match /<title>expired.badssl.com<\/title>/ }
  its(:stderr) { should match /HTTP\/1.1 200 OK/ }
  its(:exit_status) { should eq 0 }
end
