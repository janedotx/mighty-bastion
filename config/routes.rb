Rails.application.routes.draw do
  post 'games/challenge' => 'games#challenge'
  get  'games/help' => 'games#help'
  post 'games/move' => 'games#move'
  get 'games/display' => 'games#display'
  post 'games/cheat' => 'games#cheat'
end
