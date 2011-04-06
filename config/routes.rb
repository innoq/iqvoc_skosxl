Rails.application.routes.draw do

  scope '(:lang)' do
    resources :taxon_ranks
  end

  scope ':lang' do
    get "ranked_concepts" => "ranked_concepts#index"

  end

end
