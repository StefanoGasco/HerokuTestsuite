# frozen_string_literal: true

require 'selenium-webdriver'

CHAT_PAGE = 'http://bekos1.herokuapp.com/languages'

# Functionalities on webpage
class HerokuWebGui
  def initialize
    @url = 'http://bekos1.herokuapp.com'
  end

  def start
    @driver = Selenium::WebDriver.for :firefox
  end

  def teardown
    @driver.quit
  end

  def reach_website
    @driver.get(@url)
  end

  def registration(username, password, name, surname)
    @driver.find_element(:link, 'Sign up').click
    @driver.find_element(:id, 'user_login').send_keys(username)
    @driver.find_element(:id, 'user_password').send_keys(password)
    @driver.find_element(:id, 'user_first_name').send_keys(name)
    @driver.find_element(:id, 'user_last_name').send_keys(surname)
    @driver.find_element(:id, 'signup-btn').click
  end

  def login(username, password)
    @driver.find_element(:id, 'login').send_keys(username)
    @driver.find_element(:id, 'password').send_keys(password)
    @driver.find_element(:id, 'login-btn').click
  end

  def in_chatpage?
    @driver.current_url.start_with? CHAT_PAGE
  end

  def search_error_message
    @driver.find_element(:class, 'alert').text
  rescue Selenium::WebDriver::Error::NoSuchElementError
    'No alert displayed'
  end
end
