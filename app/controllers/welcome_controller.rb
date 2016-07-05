class WelcomeController < ApplicationController
  def index
    render plain: 'hi'
  end
end
