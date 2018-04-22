begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"

  gem "rake"
  gem "hanami-events", github: "hanami/events"
  gem "rspec"
  gem "rspec-core"
end

require 'hanami/events'
require 'rspec'
require 'rspec/autorun'

RSpec.describe Hanami::Events do
  let(:events) { Hanami::Events.new(:memory_sync) }
  let(:event_name) { 'user.created' }

  before { events.subscribe(event_name) { |payload| payload } }

  it { expect(events.broadcast('user.created', user_id: 1)).to eq([{ user_id: 1 }]) }
end
