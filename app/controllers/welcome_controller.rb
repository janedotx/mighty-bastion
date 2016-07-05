class WelcomeController < ApplicationController
  def index
    render plain: 'hi'
  end

  def ssl
    render plain: 'vKn8WrehP-J-w9psnrcWOaYagOoup3nqR0MyxGoWIK8.akXVc7P_zF82JwQ5zF3fvSawy6xznvLDL9GY3glez6o'
  end
end
