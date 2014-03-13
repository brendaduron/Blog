require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"

class DeTodo < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :firefox
    @base_url = 'http://blogvyv.herokuapp.com'
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 230
    @verification_errors = []
  end

  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end

  def test_de_todo
    @driver.get(@base_url + '/')
    @driver.find_element(:link, 'Nuevo Post').click
    @driver.find_element(:id, 'post_title').clear
    @driver.find_element(:id, 'post_title').send_keys 'DuvoPost'
    @driver.find_element(:id, 'post_body').clear
    @driver.find_element(:id, 'post_body').send_keys 'Este es el post del Duvo'
    @driver.find_element(:css, 'button.btn.btn-success').click
    @driver.find_element(:link, 'Nuevo Post').click
    @driver.find_element(:id, 'post_title').clear
    @driver.find_element(:id, 'post_title').send_keys 'BrendaPost'
    @driver.find_element(:id, 'post_body').clear
    @driver.find_element(:id, 'post_body').send_keys 'Este es el post de Brenda'
    @driver.find_element(:css, 'button.btn.btn-success').click
    @driver.find_element(:link, 'Nuevo Post').click
    @driver.find_element(:id, 'post_title').clear
    @driver.find_element(:id, 'post_title').send_keys 'RicardoPost'
    @driver.find_element(:id, 'post_body').clear
    @driver.find_element(:id, 'post_body').send_keys 'Este es el post de Ricardo'
    @driver.find_element(:css, 'button.btn.btn-success').click
    @driver.find_element(:link, 'Nuevo Post').click
    @driver.find_element(:id, 'post_title').clear
    @driver.find_element(:id, 'post_title').send_keys '2am Post'
    @driver.find_element(:id, 'post_body').clear
    @driver.find_element(:id, 'post_body').send_keys 'Este es el post de las 2 am'
    @driver.find_element(:css, 'button.btn.btn-success').click
    @driver.find_element(:link, 'Home').click
    @driver.find_element(:name, 'query').clear
    @driver.find_element(:name, 'query').send_keys 'post'
    @driver.find_element(:css, 'button.btn.btn-success').click
    @driver.find_element(:link, 'Home').click
    @driver.find_element(:name, 'query').clear
    @driver.find_element(:name, 'query').send_keys 'Post'
    @driver.find_element(:css, 'button.btn.btn-success').click
    verify { assert_equal 'DuvoPost', @driver.find_element(:link, 'DuvoPost').text }
    verify { assert_equal 'BrendaPost', @driver.find_element(:link, 'BrendaPost').text }
    verify { assert_equal 'RicardoPost', @driver.find_element(:link, 'RicardoPost').text }
    verify { assert_equal '2am Post', @driver.find_element(:link, '2am Post').text }
    @driver.find_element(:link, 'DuvoPost').click
    @driver.find_element(:id, 'post_title').clear
    @driver.find_element(:id, 'post_title').send_keys 'el pollito Pio'
    @driver.find_element(:id, 'post_body').clear
    @driver.find_element(:id, 'post_body').send_keys 'el pollito pio pio pio pio pio'
    @driver.find_element(:css, 'button.btn.btn-success').click
    verify { assert_equal 'DuvoPost', @driver.find_element(:css, 'h1').text }
    @driver.find_element(:link, 'Home').click
    @driver.find_element(:name, 'query').clear
    @driver.find_element(:name, 'query').send_keys 'Post'
    @driver.find_element(:css, 'button.btn.btn-success').click
    @driver.find_element(:link, 'BrendaPost').click
    @driver.find_element(:link, 'Borrar Post').click
    @driver.find_element(:link, 'RicardoPost').click
    @driver.find_element(:link, 'Borrar Post').click
    @driver.find_element(:link, 'DuvoPost').click
    @driver.find_element(:link, 'Borrar Post').click
    verify { assert_equal '2am Post', @driver.find_element(:link, '2am Post').text }
    @driver.find_element(:link, '2am Post').click
    @driver.find_element(:link, 'Borrar Post').click
  end

  def element_present?(how, what)
    $receiver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def alert_present?
    $receiver.switch_to.alert
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
    alert = $receiver.switch_to.alert
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
