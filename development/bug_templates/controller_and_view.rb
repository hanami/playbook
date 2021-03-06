begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"

  gem "rake"
  gem "hanami-controller", github: "hanami/controller"
  gem "hanami-view", github: "hanami/view"
  gem "rspec"
  gem "rspec-core"
end


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

require 'hanami/view'

module Books
  class Index
    include Hanami::View

    def render(_context)
      nil
    end
  end
end

Hanami::View.load!

require 'rspec'
require 'rspec/autorun'

require 'rspec'
require 'rspec/autorun'

RSpec.describe Books::Index do
  let(:action) { described_class.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    expect(response[0]).to eq 200
    expect(response[2]).to eq ['Hello from Books::Index']
  end

  it 'exposes all books' do
    action.call(params)
    expect(action.exposures[:books]).to eq []
  end
end

__END__
<html>
  <head>
    <title>Super Simple Hanami App</title>
  </head>
  <body>
    <%= header %>
  </body>
</html>
