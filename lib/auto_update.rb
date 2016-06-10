require "auto_update/version"
require "auto_update/const"
require 'capybara'
require 'capybara/poltergeist'
# require 'pry'

module AutoUpdate
  class Starwood
    extend Capybara::DSL
    Capybara.default_driver = :poltergeist
    Capybara.default_wait_time = 8
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {js_errors: false})
    end

    def self.login_with login, password, dev_id=nil
      visit "https://www.starwoodhotels.com/preferredguest/account/sign_in.html?language=en_US"
      page.driver.set_cookie("deviceId", dev_id) if dev_id
      # Acc: 44820011101, sa!lb0at
      within('.loginForm') do
        fill_in 'login', with: login
        fill_in 'password', with: password
        click_button 'checkSubmit'
      end
      if first(".errorFor")
        status =
          if first(".errorFor").text.include?('is locked')
            STATUS_LOCKOUT
          else
            STATUS_LOGIN_ERROR
          end
        [first(".errorFor").text, status]
      else
        # Capybara.reset_sessions!
        STATUS_LOGIN_OK
        # dev_id && first(".question").nil? ? points : send_question(dev_id)
      end
    end

    def self.send_question
      unless first(".question").nil?
        question_text = page.find('.question').text
        p question_text
        answare = gets.chomp
      end
      question_text
      # answare_to_question answare
    end

    def self.answare_to_question answare
      fill_in 'securityAnswer', with: answare
      page.find(:xpath,"//label[@data-form='securityQForm']").click
      within('#securityQForm') do
        click_button 'checkSubmit'
      end
      answare_with_error
    end

    def self.answare_with_error
      until first(".error").nil? do
        answare_error = first(".error").text
        p answare_error
        p page.find('.question').text
        answare = gets.chomp
        fill_in 'securityAnswer', with: answare
        within('#securityQForm') do
          page.save_screenshot("before_click.png")
          click_button 'checkSubmit'
        end
      end
      points
    end

    def self.points
      points = page.find('#starpoints p').text.to_i
      device_id = page.driver.cookies.map { |c| c[1].value if c[1].name == "deviceId" }.compact.first
      Capybara.reset_sessions!
      [points, device_id]
    end

  end
end
