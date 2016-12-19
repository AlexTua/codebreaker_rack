require 'erb'
require './lib/game.rb'
require 'yaml'

class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @game = game
  end

  def response
    case @request.path
      when '/' then Rack::Response.new(render('index.html.erb'))
      when '/check_guess' then check_guess
      when '/restart' then restart 
      when '/hint' then hint 
      when '/save' then save
      else Rack::Response.new('Not Found', 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def game
    @request.session[:game] ||= Codebreaker::Game.new
  end

  def check_guess
    @request.session[:guess] = @request.params['guess']
    @request.session[:answer] = @game.check_guess(@request.params['guess'])
    redirect_to('/')
  end

  def restart
    @request.session.clear
    redirect_to('/')
  end

  def hint
    @request.session[:hint] = @game.hint
    redirect_to('/')
  end

  def save
    File.new('records.yaml', 'w') unless File.exist?('records.yaml')

    data = @game.to_h
    data[:name] = @request.params['name']

    statistics = records || []
    statistics << data

    File.open('records.yaml', "w") do |f|
      f.write(statistics.to_yaml)
    end
    redirect_to('/restart')
  end

  def records
    YAML.load_file('records.yaml')
  end

  def sorted_records
    return [] unless records
    records.sort_by { |record| record[:attempts_used] }
  end 

  def redirect_to(path)
    Rack::Response.new do |response|
      response.redirect(path)
    end
  end

  def session_data(data)
    @request.session[data]
  end
end