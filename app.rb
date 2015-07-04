require 'sinatra'
require 'sinatra/activerecord'
require './models.rb'
require 'rack-flash'

configure(:development){set :database, "sqlite3:blog.sqlite3"}

enable :sessions 

use Rack::Flash, sweep: true

def current_user
 if session[:user_id]
   User.find session[:user_id]
 end
end

get'/' do 
  @title = "Nneoma"
  erb :home
end

post '/sign-in' do 
  @title = "Nneoma"
  username = params["username"]
  password = params["password"]
  @user = User.where(username: username).first
  
  if @user.password == password
    session[:user_id] = @user.id
    redirect '/feed'
  else
    redirect '/'
  end
  erb :home
end

get '/sign-up' do 
  @title = "Sign up for Nneoma!"
  erb :sign_up
end

post '/sign-up' do
  confirmation = params[:confirm_password]
  if confirmation == params[:user][:password]
    @user = User.create(params[:user])
            @user.create_profile(city: params[:profile][:city], description: params[:profile][:description])

    flash[:notice] = "Thanks for signing up, #{@user.username}"
  else
    flash[:notice] = "Your password & confirmation did not match, try again"
    redirect '/sign-up'
  end
end

get '/profile' do
  @title =  "profile"
  if current_user
    @posts = current_user.posts
    @username = current_user.username
    @city = current_user.profile.city
    @description = current_user.profile.description
  end
  erb :profile
end

post '/profile' do
  @user.update_attributes(params[:user])
  @user.profile.update_attributes(params[:profile])
  flash[:notice] = "Your account has been updated"
  erb :edit
end

post '/account_delete' do
  current_user.delete
  session.clear
  flash[:warning] = "Your account has been deleted."
  redirect '/'
end

get '/feed' do
  @user = current_user if current_user
  @title = "Nneomafeed"
  @feed_posts = Post.last(10)
  erb :feed
end

post '/feed' do
  @user = current_user if current_user
  @title = "Nneomafeed"
  if params[:body] != ''
    @user.posts.create(body: params[:body], user_id: current_user.id)
  end
  redirect '/feed'
end
