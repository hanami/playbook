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
  gem "hanami-controller", github: "hanami/controller"
  gem "rspec"
  gem "rspec-core"
end

require 'hanami/router'

module Books
  class Index
    include Hanami::Action
    expose :books

    def call(params)
      @books = []
      self.body = 'Hello from Books::Index'
    end
  end
end

Application = Hanami::Router.new do
  get '/books/:id', to: Books::Index
end

require 'rspec'
require 'rspec/autorun'

RSpec.describe Application do
  let(:env) { {} }
  subject { Application.recognize('/books/123') }

  it { expect(subject.verb).to eq 'GET' }
  it { expect(subject.params).to eq(id: '123') }

  it 'returns array of http attributes' do
    expect(subject.call(env)).to eq [
      200, { 'Content-Type' => 'application/octet-stream; charset=utf-8' }, ['Hello from Books::Index']
    ]
  end
end
