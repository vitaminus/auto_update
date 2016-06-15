module AutoUpdate
  def self.capybara_settings
    Capybara.default_driver = :poltergeist
    Capybara.default_wait_time = 8
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {js_errors: false})
    end
  end
end
