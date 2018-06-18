begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"

  gem "rake"
  gem "hanami-mailer", github: "hanami/mailer"
  gem "rspec"
  gem "rspec-core"
end

Hanami::Mailer.configure do
  delivery_method :test
  root './development/bug_templates/templates'
end.load!

require 'hanami/mailer'

class WelcomeMailer
  include Hanami::Mailer

  template 'welcome_mailer'

  from 'noreply@sender.com'
  to   ['noreply@recipient.com', 'owner@recipient.com']
  cc   'cc@recipient.com'
  bcc  'bcc@recipient.com'

  subject 'Welcome'
end
WelcomeMailer.templates

require 'rspec'
require 'rspec/autorun'

RSpec.describe WelcomeMailer do
  let(:mailer) { WelcomeMailer.new }

  before { Hanami::Mailer.deliveries.clear }

  it 'renders the given template' do
    expect(mailer.render(:txt)).to eq "This is a txt template\n"
  end

  it 'can deliver' do
    expect { WelcomeMailer.deliver(format: :txt) }.to change { Hanami::Mailer.deliveries.count }.by(1)
  end
end
