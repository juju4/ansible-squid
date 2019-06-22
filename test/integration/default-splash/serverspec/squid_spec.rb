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
