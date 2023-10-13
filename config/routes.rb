Rails.application.routes.draw do
  scope ':lang', constraints: Iqvoc.routing_constraint do
    resources :labels

    post 'labels/versions/:origin/branch' => 'labels/versions#branch', :as => 'label_versions_branch'
    post 'labels/versions/:origin/merge' => 'labels/versions#merge', :as => 'label_versions_merge'
    post 'labels/versions/:origin/to_review' => 'labels/versions#to_review', :as => 'label_versions_to_review'
    get 'labels/versions/:origin/consistency_check' => 'labels/versions#consistency_check', :as => 'label_versions_consistency_check'
    get 'labels/:origin/duplicate' => 'labels#duplicate', :as => 'label_duplicate'
    get 'label_dashboard' => 'xl_dashboard#label_index', as: 'label_dashboard'
    get 'concept_new_label' => 'labels#new_from_concept', as: 'concept_new_label'
    post 'concept_create_label' => 'labels#create_from_concept', as: 'concept_create_label'
  end
end
