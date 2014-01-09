require 'spec_helper_acceptance'

describe 'apt::force define' do
  context 'defaults' do
    it 'should work with no errors' do
      pp = <<-EOS
      include apt
      apt::force { 'vim': }
      EOS

      shell('apt-get remove -y vim')
      apply_manifest(pp, :catch_failures => true)
    end

    describe package('vim') do
      it { should be_installed }
    end
  end

  context 'release' do
    it 'should work with no errors' do
      pp = <<-EOS
      include apt
      apt::force { 'vim': release => 'precise' }
      EOS

      shell('apt-get remove -y vim')
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/apt-get -y -t precise install vim/)
      end
    end

    describe package('vim') do
      it { should be_installed }
    end
  end

  context 'version' do
    it 'should work with no errors' do
      pp = <<-EOS
      include apt
      apt::force { 'vim': version => '1.1.1' }
      EOS

      shell('apt-get remove -y vim')
      apply_manifest(pp, :catch_failures => false) do |r|
        expect(r.stdout).to match(/apt-get -y  install vim=1.1.1/)
      end
    end

    describe package('vim') do
      it { should_not be_installed }
    end
  end

  context 'timeout' do
    it 'should work with no errors' do
      pp = <<-EOS
      include apt
      apt::force { 'tomcat7': timeout => '1' }
      EOS

      shell('apt-get clean')
      apply_manifest(pp, :expect_failures => true) do |r|
        expect(r.stderr).to match(/Error: Command exceeded timeout/)
      end
    end

    describe package('vim') do
      it { should_not be_installed }
    end
  end

end
