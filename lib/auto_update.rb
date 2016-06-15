require "auto_update/version"
require "auto_update/const"
require "auto_update/settings"
require "auto_update/alaska"
require "auto_update/starwood"
require 'capybara'
require 'capybara/poltergeist'
# require 'pry'

module AutoUpdate
  # def self.AutoUpdate provider
  #   puts "asdajsdkjas"
  #   const_get("AutoUpdate::#{provider.capitalize}").new
  # rescue NameError
  #   fail "Неизвестный провайдер"
  # end
  # class Provider
  #   attr_reader :login, :password
  #   def initialize(login, password)
  #     @login    = login
  #     @password = password
  #   end
  # end
end
