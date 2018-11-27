# frozen_string_literal: true
#
# inspec controls designed to run exec against docker://$ID target

title 'Container Images and Build File'

control 'cis-docker-benchmark-4.1' do
  impact 1.0
  title 'Ensure a user for the container has been created (Scored)'
  desc 'Create a non-root user for the container in the Dockerfile for the container image.'
  tag 'level:1'

  ref 'Secure Engine', url: 'https://docs.docker.com/engine/security/'

  docker.containers.running?.ids.each do |id|
    describe docker.object(id) do
      skip 'ephemeral build container used on circleci - USER intentionally not defined'
      # its(%w(Config User)) { should_not eq nil }
    end
  end
end

control 'cis-docker-benchmark-4.2' do
  impact 1.0
  title 'Ensure that containers use trusted base images (Not Scored)'
  desc 'Ensure that the container image is written either from scratch or is based on another established and trusted base image downloaded over a secure channel.'
  tag 'level:1'

  ref url: 'https://hub.docker.com/r/library/alpine/'

  describe os_env('DOCKER_CONTENT_TRUST') do
    skip 'Content trust and signing currently not activated.'
    # its('content') { should eq '1' }
  end
end

control 'cis-docker-benchmark-4.3' do
  impact 1.0
  title 'Ensure unnecessary packages are not installed in the container'
  desc 'Containers tend to be minimal and slim down versions of the Operating System. Do not install anything that does not justify the purpose of container.'
  tag 'level:1'

  ref url: 'https://alpinelinux.org'

  describe 'do not install unnecessary packages' do
    skip 'configuration controls validate base os family as alpine to prevent unknown packages in starting point. All other installs tested and intentional.'
  end
end

control 'cis-docker-benchmark-4.4' do
  impact 1.0
  title 'Ensure images are scanned and rebuilt to include security patches (Not Scored)'
  desc 'Images should be scanned frequently for any vulnerabilities. Rebuild the images to include patches and instantiate new containers from it.'
  tag 'level:1'

  describe 'scan images for vulnerabilities and rebuild rather than patch' do
    skip 'organization deploys images to quay.io which includes clair vulnerability scanning'
  end
end

control 'cis-docker-benchmark-4.5' do
  impact 1.0
  title 'Enable Content trust for Docker is enabled (Scored)'
  desc 'Content trust provides the ability to use digital signatures for data sent to and received from remote Docker registries. These signatures allow client-side verification of the integrity and publisher of specific image tags. This ensures provenance of container images. Content trust is disabled by default. You should enable it.'
  tag 'level:2'

  describe os_env('DOCKER_CONTENT_TRUST') do
    skip 'Content trust and signing currently not activated.'
    # its('content') { should eq '1' }
  end
end

control 'cis-docker-benchmark-4.6' do
  impact 0.0
  title 'Ensure HEALTHCHECK instruction have been added to the container image (Scored)'
  desc 'Add HEALTHCHECK instruction in your docker container images to perform the health check on running containers.'
  tag 'level:1'

  docker.containers.running?.ids.each do |id|
    describe docker.object(id) do
      skip 'conatiner has limited life span and circleci manages container orchestration'
      # its(%w(Config Healthcheck)) { should_not eq nil }
    end
  end
end

control 'cis-docker-benchmark-4.7' do
  impact 0.0
  title 'Ensure update instructions are not used alone in the Dockerfile (Not Scored)'
  desc 'Adding the update instructions in a single line on the Dockerfile will cache the update layer. Alternatively, you could use --no-cache flag during docker build process to avoid using cached layers.'
  tag 'level:1'

  # by convention we will always include upgrade with update to prevent cache
  docker.images.ids.each do |id|
    describe command("docker history #{id}| grep -e '/update(?! upgrade)/g'") do
      its('stdout') { should eq '' }
    end
  end
end

control 'cis-docker-benchmark-4.8' do
  impact 0.0
  title 'Ensure setuid and setgid permissions are removed in the images (Not Scored)'
  desc 'setuid and setgid permissions could be used for elevating privileges. Allow setuid and setgid permissions only on executables which need them. '
  tag 'level:2'

  ref url: 'http://man7.org/linux/man-pages/man2/setuid.2.html'
  ref url: 'http://man7.org/linux/man-pages/man2/setgid.2.html'
  ref 'DevSec Linux Baseline', url: 'https://github.com/dev-sec/linux-baseline'

  # circleci agents are short-lived and this minimizes the elevated privilege risk from attack
  describe 'setuid and setgid permissions' do
    skip 'starting from alpine base, all installed packages with executables use default'
  end
end

control 'cis-docker-benchmark-4.9' do
  impact 0.3
  title 'Ensure COPY is used instead of ADD in Dockerfile (Not Scored)'
  desc 'COPY instruction just copies the files from the local host machine to the container file system. ADD instruction potentially could retrieve files from remote URLs and perform operations such as unpacking.'
  tag 'level:1'

  docker.images.ids.each do |id|
    describe command("docker history #{id}| grep '/ADD(?! file:)/g'") do
      its('stdout') { should eq '' }
    end
  end
end

control 'cis-docker-benchmark-4.10' do
  impact 0.0
  title 'Ensure secrets are not installed in Dockerfiles (Not Scored)'
  desc 'Do not store any secrets in Dockerfile and these can be easily revealed using docker native commands.'
  tag 'level:1'

  describe 'Dockerfile test' do
    skip 'Use aws-secrets to validate repo contents'
  end
end

control 'cis-docker-benchmark-4.11' do
  impact 0.0
  title 'Ensure verified packages are only installed (Not Scored)'
  desc 'Verifying authenticity of the packages is essential for building a secure container image.'
  tag 'level:1'

  ref url: 'https://alpinelinux.org'

  describe 'Verify packages' do
    skip 'Use GPG keys for downloading and verifying packages or any other secure package distribution mechanism of your choice.'
  end
end