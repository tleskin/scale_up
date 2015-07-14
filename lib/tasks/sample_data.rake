require 'populator'

namespace :sample_data do
  desc "Load pre-generated PG data into Dev db"
    task :populate => :environment do
      @venues = Venue.all
      @categories = Category.all
      @images = Image.all

      Event.populate(30_000) do |event|
        event.title = Faker::Company.name
        event.description = Faker::Company.catch_phrase
        event.date = 22.days.from_now
        event.start_time = "2000-01-01 22:30:00"
        event.approved = true
        event.image_id = @images.sample.id
        event.venue_id = @venues.sample.id
        event.category_id = @categories.sample.id
        puts "created event #{event.id}"
      end

      @event = Event.all

      User.populate(200_000) do |user|
        user.full_name    = Faker::Name.name
        user.email        = Faker::Internet.email
        user.display_name = Faker::Internet.user_name
        user.password_digest = "password"
        user.slug = user.full_name.gsub(" ", "-")
        user.street_1 = Faker::Address.street_address
        user.street_2 = Faker::Address.secondary_address
        user.city = Faker::Address.city
        user.state = Faker::Address.state
        user.zipcode = 80301
        puts "created user #{user.id}"

        Item.populate(3) do |item|
          item.unit_price = Faker::Commerce.price
          item.pending = false
          item.sold = false
          item.section = rand(1..100)
          item.row = rand(1..50)
          item.seat = rand(1..20)
          item.delivery_method = "electronic"
          item.event_id = @event.sample.id
          item.user_id = user.id
          puts "created item #{item.id} for user #{user.id}"
        end
      end

      Order.populate(50_000) do |order|
        order.user_id = User.find(rand(200_000) + 1).id
        order.status = "ordered"
        puts "created order #{order.id}"
      end
    end
end
