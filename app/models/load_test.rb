require 'capybara/poltergeist'

class LoadTest
  attr_reader :session

  ERRORS = [
  EOFError,
  NoMethodError,
  Errno::ECONNRESET,
  Errno::EINVAL,
  Errno::EBADF,
  Net::HTTPBadResponse,
  Net::HTTPHeaderSyntaxError,
  Net::ProtocolError,
  Timeout::Error,
  Capybara::ElementNotFound
]

  def initialize
    @session = Capybara::Session.new(:poltergeist)
  end

  def browse
    loop do
      begin
        loop do
          visit_root
          adventure
          log_in("taytay@swift.com", "password")
          create_ticket
          past_orders
          edit_profile
          search_events
          log_out
        end
        rescue StandardError => error
          puts "ERROR: #{error}"
          if session.find_link('Logout')
            log_out
            browse
          else
            browse
          end
      end
    end
  end

  private

  def visit_root
    session.visit("http://localhost:3000/")
    puts "At root"
  end

    def log_in(email, password)
    session.click_link("Login")
    session.fill_in "session[email]", with: email
    session.fill_in "session[password]", with: password
    session.click_link_or_button("Log in")
    puts "User is logged in"
  end

  def adventure
    visit_root
    session.click_link("Adventure")
    puts "Visited Adventure path"
  end

  def past_orders
    session.click_link("My Hubstub")
    session.click_link("Past Orders")
    session.click_link("My Hubstub")
    session.click_link("My Listings")
    puts "Viewed user's past orders"
  end

  def edit_profile
    session.click_link("My Hubstub")
    session.click_link("Manage Account")
    session.click_link("Edit User Profile")
    session.fill_in "user[city]", with: "Denver"
    session.click_button("Update Account")
    puts "Profile edited"
  end

  def create_ticket
    session.click_link("My Hubstub")
    session.click_link("List a Ticket")
    puts "Visited List a Ticket"
    session.fill_in "item[event_id]", with: rand(1..20000)
    session.fill_in "item[section]", with: "A3"
    session.fill_in "item[row]", with: "123"
    session.fill_in "item[seat]", with: "5"
    session.fill_in "item[unit_price]", with: 33
    session.select  "Electronic", from: "item[delivery_method]"
    session.click_button("List Ticket")
    puts "Created ticket"

    session.click_link("My Hubstub")
    session.click_link("My Listings")
    session.all(:css, "tr.item-row").last.click_button("Edit Listing")
    session.fill_in "item[section]", with: "A3"
    session.click_button("Submit")
    puts "Edited ticket"

    session.all(:css, "tr.item-row").last.click_button("Delete Listing")
    puts "Deleted ticket"
  end

  def log_out
    session.click_link("Logout")
    puts "User logged out"
  end

  def search_events
    session.click_link("Buy")
    session.click_link("All Tickets")
    session.click_link("All")
    session.click_link("Sports")
    session.click_link("Music")
    session.click_link("Comedy")
    session.click_link("Conference")
    session.click_link("Attaction")
    session.click_link("Tour")
    session.click_link("Seminar")
    session.click_link("Networking")
    session.click_link("Tournament")
    session.click_link("Festival")
    session.click_link("Rally")
    session.click_link("Expo")
    session.click_link("Party")
    puts "events filter used"
  end

  def add_to_cart_create_account
    session.click_link("Buy")
    session.click_link("All Tickets")
    session.all("p.event-name a").sample.click
    session.first(:button, "Add to cart").click
    puts "Item added to cart"
    session.click_link("Cart(1)")
    session.click_link("Checkout")
    session.click_link("here")


    session.fill_in "user[full_name]", with: "Shaq"
    session.fill_in "user[display_name]", with: ("A".."Z").to_a.shuffle.first(2).join
    session.fill_in "user[email]", with: (1..20).to_a.shuffle.join + "@sample.com"
    session.fill_in "user[street_1]", with: "Main St."
    session.fill_in "user[city]", with: "Denver"
    session.select  "Colorado", from: "user[state]"
    session.fill_in "user[zipcode]", with: "80301"
    session.fill_in "user[password]", with: "password"
    session.fill_in "user[password_confirmation]", with: "password"
    session.click_button("Create my account!")

    session.click_link("Cart(1)")
    session.click_link_or_button("Remove")
    puts "add item to cart, create account, and remove cart item"
  end

  def admin_edit_event
    log_in("admin@admin.com", "password")
    session.click_link "Users"
    session.all("tr").sample.click_link "Store"
    session.click_link "Events"
    session.click_link "Manage Events"
    session.click_link("Edit", :match => :first)
    session.fill_in "event[title]", with: ("A".."Z").to_a.shuffle.first(5).join
    session.fill_in "event[date]", with: 33.days.from_now.change({ hour: 5, min: 0, sec: 0  })
    session.fill_in "event[start_time]", with: "2000-01-01 19:00:00"
    session.click_button "Submit"
    log_out
    puts "admin event edit"
  end

  def admin_create_and_delete_event
    log_in("admin@admin.com", "password")
    session.click_link "Manage Events"
    session.click_link "Create Event"
    session.fill_in "event[title]", with: "Sample Ticket"
    session.fill_in "event[description]", with: "No description necessary."
    session.fill_in "event[date]", with: 33.days.from_now.change({ hour: 5, min: 0, sec: 0  })
    session.fill_in "event[start_time]", with: "2000-01-01 19:00:00"
    session.click_button "Submit"
    puts "admin create event"
  end


  def log_in(email, password)
    session.click_link("Login")
    session.fill_in "session[email]", with: email
    session.fill_in "session[password]", with: password
    session.click_link_or_button("Log in")
  end

end
