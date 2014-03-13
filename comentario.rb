require 'json'
require 'selenium-webdriver'
gem 'test-unit'
require 'test/unit'

# la le li lo lu
class Comentarios < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :firefox
    @base_url = 'http://blogvyv.herokuapp.com'
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 250
    @verification_errors = []
  end

  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end

  def test_comentarios
    @driver.get(@base_url + '/')
    @driver.find_element(:link, 'Nuevo Post').click
    @driver.find_element(:id, 'post_title').clear
    @driver.find_element(:id, 'post_title').send_keys 'comentarios selenium'
    @driver.find_element(:id, 'post_body').clear
    @driver.find_element(:id, 'post_body').send_keys 'selenium comentarios prueba ahuaaaaaaaaaaaaaaaaa'
    @driver.find_element(:css, 'button.btn.btn-success').click
    verify { assert_equal 'comentarios selenium', @driver.find_element(:css, 'h1').text }
    @driver.find_element(:id, 'post_title').clear
    @driver.find_element(:id, 'post_title').send_keys 'y arriba Jerez jajaja'
    @driver.find_element(:id, 'post_body').clear
    @driver.find_element(:id, 'post_body').send_keys 'y tambien Nochistlan'
    @driver.find_element(:css, 'button.btn.btn-success').click
    verify { assert_equal 'y arriba Jerez jajaja', @driver.find_element(:css, 'b').text }
    @driver.find_element(:link, 'Borrar Post').click
  end

  def element_present?(how, what)
    receiver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def alert_present?
    receiver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end

  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end

  def close_alert_and_get_its_text(how, what)
    alert = receiver.switch_to.alert
    alert_text = alert.text
    if @accept_next_alert
      alert.accept
    else
      alert.dismiss
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
