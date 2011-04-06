Rails.application.routes.draw do

  scope ':lang', :lang => available_locales do

    resources :labels

    match "concepts/versions/:origin/branch(.:format)"      => "concepts/versions#branch",    :as => "concept_versions_branch"
    match "concepts/versions/:origin/merge(.:format)"       => "concepts/versions#merge",     :as => "concept_versions_merge"
    match "concepts/versions/:origin/lock(.:format)"        => "concepts/versions#lock",      :as => "concept_versions_lock"
    match "concepts/versions/:origin/unlock(.:format)"      => "concepts/versions#unlock",    :as => "concept_versions_unlock"
    match "concepts/versions/:origin/to_review(.:format)"   => "concepts/versions#to_review", :as => "concept_versions_to_review"
    match "concepts/versions/:origin/consistency_check(.:format)" => "concepts/versions#consistency_check", :as => "concept_versions_consistency_check"

  end

end
