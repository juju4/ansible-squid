require 'serverspec'

# Required by serverspec
set :backend, :exec

proxy_port = 3128

describe command("curl -v -x http://localhost:#{proxy_port} https://www.google.com") do
  its(:stdout) { should match /<title>Google<\/title>/ }
  its(:stderr) { should match /HTTP\/1.1 200 OK/ }
  its(:exit_status) { should eq 0 }
end

describe command("curl -v -x http://localhost:#{proxy_port} https://www.cnn.com") do
  its(:stdout) { should match /<!DOCTYPE html><html class="no-js"><head>/ }
  its(:stderr) { should match /HTTP\/1.1 200 OK/ }
  its(:exit_status) { should eq 0 }
end
