Rails.application.routes.draw do
  scope ':lang', constraints: Iqvoc.routing_constraint do
    resources :labels

    post 'labels/versions/:origin/branch' => 'labels/versions#branch',
        :as => 'label_versions_branch'
    post 'labels/versions/:origin/merge' => 'labels/versions#merge',
        :as => 'label_versions_merge'
    post 'labels/versions/:origin/lock' => 'labels/versions#lock',
        :as => 'label_versions_lock'
    post 'labels/versions/:origin/unlock' => 'labels/versions#unlock',
        :as => 'label_versions_unlock'
    post 'labels/versions/:origin/to_review' => 'labels/versions#to_review',
        :as => 'label_versions_to_review'
    get 'labels/versions/:origin/consistency_check' => 'labels/versions#consistency_check',
        :as => 'label_versions_consistency_check'
  end
end
