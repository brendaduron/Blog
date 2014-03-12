
require 'test/unit'
require 'rack/test'

#set :enviroment, :test

begin
  require_relative 'app'
end

class MyTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_root
    get "/"
    assert last_response.ok?
   # last_response.status.must_equal 200
   # assert_equal 'Welcome', last_response.title
  end

  def test_create
    get "/posts/create"
    assert last_response.ok?
  end

 # def test_createSave
  #  post "/posts" , {:name => 'Prueba', :body => 'Hola'}
   # assert last_response.ok?
   # last_response.status.must_equal 200
   # assert last_response.body.should include("Congrats")

  end

#  def test_consultar
 #   get "/posts/:id", "id" => 2
 #   assert last_response.ok?
  #end
end 
