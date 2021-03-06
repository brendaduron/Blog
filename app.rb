# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions

set :database, 'sqlite:///dev.db' if test?

# Class Posts
class Post < ActiveRecord::Base
  has_many :comments

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true
end

# Class Comments
class Comments < ActiveRecord::Base
  belongs_to :post
end

helpers do
  def title
    if @title
      "#{@title}"
    else
      'Welcome.'
    end
  end
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

# get ALL posts
get '/' do
  @posts = Post.order('created_at DESC')
  @title = 'Welcome.'
  erb :"posts/index"
end

# create new post
get '/posts/create' do
  @title = 'Create post'
  @post = Post.new
  erb :"posts/create"
end
post '/posts' do
  @post = Post.new(params[:post])
  if @post.save
    redirect "posts/#{@post.id}", notice: 'Congrats! Love the new post.'
  else
    redirect 'posts/create', error: 'Something went wrong. Try again. '
  end
end

# view post
get '/posts/:id' do
  @post = Post.find(params[:id])
  @title = @post.title
  @comments = Comments.where("post_id = #{@post.id}")
  erb :"posts/view"
end

# edit post
get '/posts/:id/edit' do
  @post = Post.find(params[:id])
  @title = 'Edit Form'
  erb :"posts/edit"
end
put '/posts/:id' do
  @post = Post.find(params[:id])
  @post.update(params[:post])
  redirect "/posts/#{@post.id}"
end

# delete posts
get '/posts/:id/delete' do
  @post = Post.find(params[:id])
  @post.destroy
  redirect '/'
end

# search posts
get '/search' do
  # @posts = Post.find_by_title(params[:query])
  @posts = Post.where("title like '%#{params[:query]}%'")
  erb :"/posts/index"
end

# new comment
post '/posts/:id/comment' do
  @post = Post.find(params[:id])
  @comment = Comments.new(params[:post])
  if @comment.save
    @comments = Comments.where("post_id = #{@post.id}")
    redirect "posts/#{@post.id}", notice: 'Gracias por el comentario.'
  else
    redirect "posts/#{@post.id}", error: 'Something went wrong. Try again.'
  end
end

# delete comments
get '/comments/:id/borrar' do
  @comment = Comments.find(params[:id])
  idpadre = @comment.post_id
  @comment.destroy
  redirect "posts/#{idpadre}"

end
