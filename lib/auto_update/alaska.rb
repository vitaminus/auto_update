require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module AutoUpdate  
  class Alaska
    include Capybara::DSL
    # AutoUpdate.capybara_settings
    Capybara.default_driver = :poltergeist
    Capybara.default_max_wait_time = 8

    attr_reader :login, :password
    def initialize(login, password)
      @login    = login
      @password = password
    end

    def log_in
      visit "https://www.alaskaair.com/www2/ssl/myalaskaair/myalaskaair.aspx?CurrentForm=UCSignInStart&nav:account:signin&INT-_AS_NAV_-prodID:MileagePlan"
      return { state: '4' } unless first('#myalaskaair')
      within('#myalaskaair') do
        fill_in 'FormUserControl$_signInProfile$_userIdControl$_userId', with: @login
        fill_in 'FormUserControl$_signInProfile$_passwordControl$_password', with: @password
        click_button 'FormUserControl__signIn'
      end
      if first(".errorText")
        {
          state: '2',
          message: 'Incorrect login or password',
          error_message: first(".errorText").text
        }
      else
        points
      end
    end

    private

    def points
      balance = page.find('#FormUserControl__myOverview__mileagePlanInfo').text.split(/[:]/).last.to_i
      Capybara.reset_sessions!
      {
        state: '1',
        balance: balance,
        history: [],
        account_number: nil
      }
    end

  end
end
