# frozen_string_literal: true

require 'colorize'
require 'json'
require_relative 'heroku_web_gui'

# Global variables with the possible texts from alerts
LOGIN_ERROR = 'Wrong login or password.'
SIGNUP_ERROR = 'Validation failed: Login has already been taken'

# Procedures to test webpage
class TestRunner
  # make test_data readable from outside
  attr_reader :test_data

  # Initialize the class with the webdriver class and read the test data from json
  def initialize
    @bekos = HerokuWebGui.new
    @test_file = 'test_data.json'
    @test_data = JSON.parse(File.read(@test_file))
  end

  # Check if the user can access with valid credentials. Returns bool
  def valid_login
    login(@test_data['valid_user'], @test_data['valid_password'])
  end

  # Check that user is not allowed to access with wrong credentials. Returns bool
  def invalid_login_name
    login(
      @test_data['invalid_user'],
      @test_data['valid_password']
    ) == LOGIN_ERROR
  end

  # Check that user can sign up with valid credentials. Returns bool
  def valid_signup
    signup(
      "#{@test_data['base_username']}#{@test_data['users_counter'] + 1}",
      @test_data['valid_password'],
      @test_data['name'],
      @test_data['surname']
    )
  end

  # Check that user is not allowed to sign up with invalid credentials. Returns bool
  def invalid_signup
    signup(
      @test_data['valid_user'],
      @test_data['valid_password'],
      @test_data['name'],
      @test_data['surname']
    ) == SIGNUP_ERROR
  end

  private

  # Code Block to manage connection and disconnection from the webpage
  def connector
    @bekos.start
    @bekos.reach_website
    yield
    @bekos.teardown
  end

  # Login procedure. Successful if reaches the chat webpage. Returns bool
  def login(username, password)
    result = false
    connector do
      @bekos.login(username, password)
      result = @bekos.in_chatpage? || @bekos.search_error_message
    end

    result
  end

  # sign up procedure. Successful if reaches the chat webpage. Returns bool
  def signup(username, password, name, surname)
    result = false
    connector do
      @bekos.registration(username, password, name, surname)
      result = @bekos.in_chatpage? || @bekos.search_error_message
    end

    update_users_counter if result == true

    result
  end

  # Keep the counter in json file updated, to ensure always new user can be created
  def update_users_counter
    @test_data['users_counter'] += 1
    File.write(@test_file, JSON.pretty_generate(@test_data))
  end
end

# Function to color the text in the terminal.
# changes bool true to green TRUE string and
# changes bool false to red FALSE string
def color_boolean(bool)
  if bool
    'TRUE'.green
  else
    'FALSE'.red
  end
end

# Run the tests only if this file is called as main
if __FILE__ == $PROGRAM_NAME
  test_bekos = TestRunner.new
  puts 'Testing valid login...'
  puts "User can login with valid credential: #{color_boolean(test_bekos.valid_login)}"
  puts 'Testing login with wrong username...'
  puts "User is blocked when using wrong username: #{color_boolean(test_bekos.invalid_login_name)}"
  puts 'Testing valid sign up process...'
  puts "User can sign up with new credentials: #{color_boolean(test_bekos.valid_signup)}"
  puts 'Testing sign up with already existing username...'
  puts "User is blocked from signing up using already existing user: #{color_boolean(test_bekos.invalid_signup)}"
end
