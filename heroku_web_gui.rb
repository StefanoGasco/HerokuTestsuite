# frozen_string_literal: true

require 'selenium-webdriver'

# Global variable with the base address of the chat page
CHAT_PAGE = 'http://bekos1.herokuapp.com/languages'

# Functionalities on webpage
class HerokuWebGui
  # Initialize the class with the main url
  def initialize
    @url = 'http://bekos1.herokuapp.com'
  end

  # Start the webdriver. Necesserary for any other operation
  def start
    @driver = Selenium::WebDriver.for :firefox
  end

  # Stop the webdriver. Always ensure you stop the webdriver
  def teardown
    @driver.quit
  end

  # Instruct the driver to reach the tested website
  def reach_website
    @driver.get(@url)
  end

  # Start the procedure to register a new user
  # you must be in the login page to execute this procedure
  def registration(username, password, name, surname)
    @driver.find_element(:link, 'Sign up').click
    @driver.find_element(:id, 'user_login').send_keys(username)
    @driver.find_element(:id, 'user_password').send_keys(password)
    @driver.find_element(:id, 'user_first_name').send_keys(name)
    @driver.find_element(:id, 'user_last_name').send_keys(surname)
    @driver.find_element(:id, 'signup-btn').click
  end

  # Start the procedure to login
  # you must be in the login page to execute this procedure
  def login(username, password)
    @driver.find_element(:id, 'login').send_keys(username)
    @driver.find_element(:id, 'password').send_keys(password)
    @driver.find_element(:id, 'login-btn').click
  end

  # Check if the driver is currently in the chatpage
  def in_chatpage?
    @driver.current_url.start_with? CHAT_PAGE
  end

  # Check if the current page has an alert. If it has an alert,
  # the alert's text is returned. Otherwise, 'No alert displayed' is returned.
  def search_error_message
    @driver.find_element(:class, 'alert').text
  rescue Selenium::WebDriver::Error::NoSuchElementError
    'No alert displayed'
  end
end
