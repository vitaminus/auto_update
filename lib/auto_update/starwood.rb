require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module AutoUpdate
  class Starwood
    include Capybara::DSL
    # AutoUpdate.capybara_settings
    Capybara.default_driver = :poltergeist
    Capybara.default_wait_time = 8
    # Capybara.register_driver :poltergeist do |app|
    #   Capybara::Poltergeist::Driver.new(app, {js_errors: false})
    # end

    attr_reader :login, :password, :dev_id

    def initialize(login, password, dev_id)
      @login    = login
      @password = password
      @dev_id   = dev_id
    end

    def log_in
      visit "https://www.starwoodhotels.com/preferredguest/account/sign_in.html?language=en_US"
      return { state: '4' } unless first('.loginForm')
      page.driver.set_cookie("deviceId", @dev_id) if @dev_id
      # Acc: 44820011101, sa!lb0at
      within('.loginForm') do
        fill_in 'login', with: @login
        fill_in 'password', with: @password
        # click_button 'checkSubmit'
        find_button("Sign In").trigger('click')
      end
      if first(".errorFor")
        if first(".errorFor").text.include?('is locked')
          {
            state: '3',
            balance: nil,
            history: nil,
            account_number: nil,
            message: 'LOCKOUT',
            error_message: first(".errorFor").text
          }
        else
          {
            state: '2',
            message: 'Incorrect login or password',
            error_message: first(".errorFor").text
          }
        end
      elsif @dev_id && first(".question").nil?
        points
      else
        send_question
      end
    end

    def answare_to_question answare
      close_popup
      fill_in 'securityAnswer', with: answare
      hidden_field = page.find(:css, "input#registerDevice", :visible => false)
      page.find(:xpath,"//label[@data-form='securityQForm']").click unless hidden_field.checked?
      sleep 1
      find_button("Submit").trigger('click')
      sleep 2
      unless first(".error").nil?
        error = first(".error").text
        question_text = page.find('.question').text
        return [STATUS_WRONG_ANSWER, error, question_text]
      end
      points
    end

    private

    def send_question
      sleep 2
      unless first(".question").nil?
        question_text = page.find('.question').text
      end
      {
        state: '10',
        question: question_text
      }
    end

    def close_popup
      driver.find_element(:class, "fsrDeclineButton").click unless first(:class, "fsrDeclineButton").nil?
    end

    def points
      balance = page.find('#starpoints p').text.to_i
      device_id = page.driver.cookies.map { |c| c[1].value if c[1].name == "deviceId" }.compact.first
      Capybara.reset_sessions!
      {
        state: '1',
        balance: balance,
        history: [],
        account_number: nil,
        device_id: device_id
      }
    end
  end
end
