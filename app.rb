require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  @meetups = Meetup.order('name')
  @reserved_meetups = Reservation.where("user_id = ?", current_user.id)
  erb :index
end

get '/:meetup_id/show' do
  @meetup = Meetup.find(params[:meetup_id])
  erb :show
end

get "/new" do
  erb :new
end

post "/new" do
  meetup = Meetup.new(
    name: params["name"],
    description: params["description"],
    location: params["location"]
  )
  meetup.save
  flash[:notice] = "Meetup created successfully"
  redirect "/#{meetup.id}/show"
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']
  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"
  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."
  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end

post "/:meetup_id/reserve" do
  Reservation.create(user_id: current_user.id, meetup_id: params[:meetup_id])
  flash[:notice] = "Awesome, you just reserved a spot. See you soon!"
  redirect "/"
end
