# frozen_string_literal: true

require 'colorize'
require 'json'
require_relative 'heroku_web_gui'

LOGIN_ERROR = 'Wrong login or password.'
SIGNUP_ERROR = 'Validation failed: Login has already been taken'

# Procedures to test webpage
class TestRunner
  attr_reader :test_data

  def initialize
    @bekos = HerokuWebGui.new
    @test_file = 'test_data.json'
    @test_data = JSON.parse(File.read(@test_file))
  end

  def valid_login
    login(@test_data['valid_user'], @test_data['valid_password'])
  end

  def invalid_login_name
    login(
      @test_data['invalid_user'],
      @test_data['valid_password']
    ) == LOGIN_ERROR
  end

  def valid_signup
    signup(
      "#{@test_data['base_username']}#{@test_data['users_counter'] + 1}",
      @test_data['valid_password'],
      @test_data['name'],
      @test_data['surname']
    )
  end

  def invalid_signup
    signup(
      @test_data['valid_user'],
      @test_data['valid_password'],
      @test_data['name'],
      @test_data['surname']
    ) == SIGNUP_ERROR
  end

  private

  def connector
    @bekos.start
    @bekos.reach_website
    yield
    @bekos.teardown
  end

  def login(username, password)
    result = false
    connector do
      @bekos.login(username, password)
      result = @bekos.in_chatpage? || @bekos.search_error_message
    end

    result
  end

  def signup(username, password, name, surname)
    result = false
    connector do
      @bekos.registration(username, password, name, surname)
      result = @bekos.in_chatpage? || @bekos.search_error_message
    end

    update_users_counter if result == true

    result
  end

  def update_users_counter
    @test_data['users_counter'] += 1
    File.write(@test_file, JSON.pretty_generate(@test_data))
  end
end

def color_boolean(bool)
  if bool
    'TRUE'.green
  else
    'FALSE'.red
  end
end

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
