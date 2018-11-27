control 'packages' do
  impact 1.0
  title 'confirm package installation'
  desc 'confirm all desired packages are installed'
  describe command('apk info') do
    its('stdout') { should include ('openjdk8-jre-base') }
    its('stdout') { should include ('openjdk8-jre') }
    its('stdout') { should include ('openjdk8-jre-lib') }
    its('stdout') { should include ('java-common') }
    its('stdout') { should include ('ca-certificates') }
  end
end
