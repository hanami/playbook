begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"

  gem "rake"
  gem "hanami-router", github: "hanami/router"
  gem "rspec"
  gem "rspec-core"
end

require 'hanami/router'

Application = Hanami::Router.new do
  get '/books/:id', to: ->(env) { [200, {}, ['Welcome to Hanami::Router!']] }
end

require 'rspec'
require 'rspec/autorun'

RSpec.describe Application do
  let(:env) { {} }
  subject { Application.recognize('/books/123') }

  it { expect(subject.verb).to eq 'GET' }
  it { expect(subject.params).to eq(id: '123') }
  it { expect(subject.call(env)).to eq [200, {}, ['Welcome to Hanami::Router!']] }
end
