class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { false }
end
