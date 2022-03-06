# HerokuTestsuite

## Introduction
This automation tests the main functionalities of the [Bekos](http://bekos1.herokuapp.com) website.
Guides in this README are based on Linux, Ubuntu 20.04, but a similar process should work for other linux distributions, iOS and Windows.

## Installation
Install [Ruby](https://www.ruby-lang.org/en/).
```bash
sudo apt update
sudo apt install ruby-full
```
Ensure ruby is properly installed.
```bash
$ ruby --version
ruby 2.7.0p0 (2019-12-25 revision 647ee6f091) [x86_64-linux-gnu]
```
Install [Bundler](https://bundler.io/), for an easy managements of Ruby's gems:
```bash
gem install bundler
```
and ensure it is properly installed:
```bash
$ bundle -v
Bundler version 2.1.4
```
To install all the required gems, reach the main directory of this project and run:
```bash
bundle install
```
You will also need [Selenium](https://www.selenium.dev/) installed, with Firefox webdriver. Download the geckodriver from the [geckodriver repository](https://github.com/mozilla/geckodriver/releases). In the following example, geckodriver-v0.30.0-linux64.tar.gz is used. Extract the executable:
```bash
tar xzf geckodriver-v0.30.0-linux64.tar.gz
```
Add the executable to PATH. In this case, the executable is in /usr/local/bin:
```bash
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bash_profile
source ~/.bash_profile
```
ensure that geckodriver is properly installed:
```bash
$ geckodriver
1646576500817   geckodriver     INFO    Listening on 127.0.0.1:4444
```
press `Ctrl+C` to stop the process.

Now, you are ready to start the automation

## Run the automation
To run the automation, simply run `test_runner.rb`:
```bash
ruby test_runner.rb
```
