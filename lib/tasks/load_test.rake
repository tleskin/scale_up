require 'capybara/poltergeist'

desc "Simulate load against HubStub application"
task :load_test => :environment do
  1.times.map { Thread.new { LoadTest.new.browse } }.map(&:join)
end
