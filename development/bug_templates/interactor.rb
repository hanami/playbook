begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"

  gem "rake"
  gem "hanami-utils", github: "hanami/utils"
  gem "rspec"
  gem "rspec-core"
end

require 'hanami/interactor'

module Books
  class Create
    include Hanami::Interactor

    def call(payload)
      'called'
    end
  end
end

require 'rspec'
require 'rspec/autorun'

RSpec.describe Books::Create do
  let(:interactor) { described_class.new }
  let(:params) { Hash[] }

  it { expect(interactor.call(params)).to be_success }
end
