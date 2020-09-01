# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Darwinex::Config do
  subject(:config) do
    described_class.new(
      token_api: token_api,
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      max_retries: max_retries
    )
  end

  let(:token_api) { instance_double('Darwinex::Api::TokenApi') }
  let(:consumer_key) { 'consumer_key' }
  let(:consumer_secret) { 'consumer_secret' }
  let(:max_retries) { 5 }

  describe '#refresh_access_token' do
    let(:refresh_token) { 'xyz321' }

    let(:refresh_access_token_args) do
      {
        refresh_token: refresh_token,
        consumer_key: consumer_key,
        consumer_secret: consumer_secret
      }
    end

    let(:access_token) { 'access_token' }

    let(:tokens) do
      {
        'access_token' => access_token,
        'refresh_token' => 'new_refresh_token',
        'scope' => 'openid',
        'id_token' => 'a_long_string',
        'token_type' => 'Bearer',
        'expires_in' => 3600
      }
    end

    before do
      expect(token_api).to receive(:refresh_access_token).with(refresh_access_token_args).and_return(tokens)
    end

    it { expect(config.refresh_access_token(refresh_token)).to eq(tokens) }

    it { expect { config.refresh_access_token(refresh_token) }.to change { config.access_token }.to(access_token) }
  end
end
