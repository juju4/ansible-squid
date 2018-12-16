require 'serverspec'

# Required by serverspec
set :backend, :exec

describe package('lighttpd') do
  it { should be_installed }
end
describe package('php-fpm') do
  it { should be_installed }
end

describe service('lighttpd') do
  it { should be_enabled }
  it { should be_running }
end

describe service('php-fpm') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe command("curl -v http://localhost") do
  its(:stdout) { should match /<title>Powered by lighttpd<\/title>/ }
  its(:stderr) { should match /HTTP\/1.1 200 OK/ }
  its(:exit_status) { should eq 0 }
end

describe command("curl -v http://localhost/splash.php") do
  its(:stdout) { should match /<title>Proxy splash page<\/title>/ }
  its(:stderr) { should match /HTTP\/1.1 200 OK/ }
  its(:exit_status) { should eq 0 }
end
