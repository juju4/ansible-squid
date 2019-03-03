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
  its(:stderr) { should match /TLSv1.2 \(IN\)/ }
  its(:stderr) { should match /TLSv1.2 \(OUT\)/ }
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
