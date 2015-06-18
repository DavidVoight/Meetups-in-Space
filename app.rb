require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'
require 'pry'

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
  @meetups = Meetup.all.order(:name)
  erb :index
end

get '/new' do
  erb :new
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

get '/:id' do
  id = params[:id]
  @meetup = Meetup.find(id)
  @creator = Connection.where(owner: true).find_by(meetup: @meetup).user
  @attending = Connection.where(meetup: @meetup)

  erb :show
end

post '/new' do
  new_meetup = Meetup.new(name: params[:name], description: params[:description], location: params[:location])

  if authenticate!
  else
    new_meetup.save
    Connection.create(user_id: current_user.id, meetup_id: new_meetup.id, owner: true )
  end

  flash[:notice] = "You have successfully created a new Meetup!"
  redirect to("/#{new_meetup.id}")
end

post '/:id' do
  id = params[:id]
  @meetup = Meetup.find(id)

  if authenticate!
  else
    flash[:notice] = "You have joined this Meetup!"
    Connection.create(meetup_id: @meetup.id, user_id: current_user.id, owner: false)
    redirect to("/")
  end
end

get '/example_protected_page' do
  authenticate!
end
