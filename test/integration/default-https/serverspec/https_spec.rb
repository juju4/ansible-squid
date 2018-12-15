require 'serverspec'

# Required by serverspec
set :backend, :exec

describe command('curl -x http://localhost:3128 https://www.google.com'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /302 Moved/ }
  its(:exit_status) { should eq 0 }
end
describe command('curl -x http://localhost:3128 https://www.cnn.com'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /<!DOCTYPE html><html class="no-js"><head>/ }
  its(:exit_status) { should eq 0 }
end
