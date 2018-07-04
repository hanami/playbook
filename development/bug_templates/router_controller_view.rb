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
  gem "hanami-view", github: "hanami/view"
  gem "rspec"
  gem "rspec-core"
end

require 'hanami/view'
require 'hanami/router'
require 'hanami/controller'

Tilt.register Tilt::ERBTemplate, 'rb'

module MyApp
  module Controllers
    module Books
      class Show
        include Hanami::Action
        expose :book

        def call(params)
          @book = "Book: ##{params[:id]}"
        end
      end
    end
  end

  module Views
    module Books
      class Show
        include Hanami::View
      end
    end
  end
end

Hanami::View.load!

resolver = Hanami::Routing::EndpointResolver.new(namespace: MyApp)
Application = Hanami::Router.new(resolver: resolver)
Application.get '/books/:id', to: 'books#show'

require 'rspec'
require 'rspec/autorun'

RSpec.describe Application do
  let(:env) { {} }
  subject { Application.recognize('/books/123') }

  it { expect(subject.verb).to eq 'GET' }
  it { expect(subject.params).to eq(id: '123') }

  it 'returns array of http attributes' do
    require 'debug'
    expect(subject.call(env)).to eq [
      200, { 'Content-Type' => 'application/octet-stream; charset=utf-8' }, ['Hello from Books::Index']
    ]
  end
end

__END__
<html>
  <head>
    <title>Super Simple Hanami App</title>
  </head>
  <body>
    <%= book %>
  </body>
</html>
