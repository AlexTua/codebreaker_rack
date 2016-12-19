require './lib/racker.rb'

use Rack::Reloader
use Rack::Static, :urls => ['/stylesheets'], :root => 'public'
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'codebreaker_rack'
run Racker