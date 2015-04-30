require 'spec_helper'
require 'foreplay'

describe Foreplay::Engine::Secrets do
  context '#fetch' do
    it 'returns nil if there is no secret location' do
      expect(Foreplay::Engine::Secrets.new('x', nil).fetch).to be_nil
    end

    it 'fails if the secret location is not a hash' do
      expect { Foreplay::Engine::Secrets.new('x', 'y').fetch } .to raise_error(NoMethodError)
    end

    it 'returns an empty hash if the secret location has no url' do
      expect(Foreplay::Engine::Secrets.new('x', []).fetch).to eq({})
    end

    it 'returns an empty hash if the secret location does not return valid YAML' do
      expect(Foreplay::Engine::Secrets.new('x', [{ 'url' => 'http://iana.org' }]).fetch).to eq({})
    end

    it 'returns an empty hash if the secret location does not exist' do
      expect(Foreplay::Engine::Secrets.new('x', [{ 'url' => 'http://iana.org/404' }]).fetch).to eq({})
    end
  end

  context '#fetch successful' do
    let(:secrets) { { 'a' => 'x', 'b' => 'y', 'c' => 'z' } }
    let(:secret) { Foreplay::Engine::Secrets.new('', ['x']) }

    before :each do
      allow(secret).to receive(:fetch_from).and_return(secrets)
    end

    it 'does what it is told' do
      expect(secret.fetch_from).to eq(secrets)
    end

    it 'returns a hash of secrets' do
      expect(secret.fetch).to eq(secrets)
    end
  end

  context '#fetch successful with merge' do
    let(:secrets1) { { 'a' => 'x', 'b' => 'f' } }
    let(:secrets2) { { 'b' => 'y', 'c' => 'z' } }
    let(:secrets) { { 'a' => 'x', 'b' => 'y', 'c' => 'z' } }
    let(:secret) { Foreplay::Engine::Secrets.new('', ['x', 'x']) }

    before :each do
      allow(secret).to receive(:fetch_from).and_return(secrets1,secrets2)
    end

    it 'returns a hash of secrets' do
      expect(secret.fetch).to eq(secrets)
    end
  end
end
