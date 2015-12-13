require 'sinatra/base'
require './lib/game.rb'
require './lib/human.rb'
require './lib/computer.rb'
require './lib/game_manager.rb'

class RPS < Sinatra::Base
  enable :sessions
  Manager = GameManager.new(Game, Human, Computer)

  def current_game
    Manager.find_game(session[:current_game_id])
  end

  get '/' do
    erb :index
  end

  post '/new-session' do
    session[:name1] = params[:name1] 
    session[:has_ai?] = params[:name2].empty?
    session[:name2] = session[:has_ai?] ? 'Computer' : params[:name2]
    redirect '/new-game'
  end

  get '/new-game' do
    session[:current_game_id] = Manager.new_game(session)
    redirect '/play'
  end

  get '/play' do
    erb :play, locals: { game: current_game }
  end

  post '/choice' do
    current_game.add_choice(params[:chooser], params[:shape])
    redirect '/play' if current_game.player2_turn?
    redirect '/result'
  end

  get '/result' do
    erb :result, locals: { game: current_game }
  end
end
