require 'minitest/autorun'
require 'rack/test'
require 'simplecov'
SimpleCov.start

# set :enviroment, :test

begin
  require_relative 'app'
end

# Clase de pruebas
class MyTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_root
    get '/'
    assert last_response.ok?
    assert_equal 200, last_response.status
  end

  def test_linkcreate
    get '/posts/create'
    assert last_response.ok?
    assert_equal 200, last_response.status
    @post = Post.new
    assert last_request
    request 'posts/create'
    assert last_request
  end

  # def test_consultar
    # @post = Post.new
    # get '/posts/:id', params = { id: @post.id }
    # assert last_response.ok?
    # get '/posts/:id', params = { id: 2 }
    # assert_equal 'http://example.org/posts/:id?id=2', last_request.url
    # assert last_request
    # assert_equal '2', last_request.params['id']
  # end

  # def test_consultarerror
    # get '/posts/:id', params = { id: 'A' }
    # assert_equal 'http://example.org/posts/:id?id=A', last_request.url
    # assert last_request
    # get '/posts/:id?id=A'
    # assert_equal 500, last_response.status
  # end

  def test_search
    get '/search' , params = { query: 'brenda' }
    assert last_response.ok?
    @posts = Post.where("title like '%#{params[:query]}%'")
    assert last_request
    # get '/posts/index'
    # assert_equal 500, last_response.status
  end
end
