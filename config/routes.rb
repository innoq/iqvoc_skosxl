Rails.application.routes.draw do
  scope '(:lang)', :lang => /#{Iqvoc::Concept.pref_labeling_languages.join("|")}/ do

    resources :labels

    match "labels/versions/:origin/branch(.:format)"      => "labels/versions#branch",    :as => "label_versions_branch"
    match "labels/versions/:origin/merge(.:format)"       => "labels/versions#merge",     :as => "label_versions_merge"
    match "labels/versions/:origin/lock(.:format)"        => "labels/versions#lock",      :as => "label_versions_lock"
    match "labels/versions/:origin/unlock(.:format)"      => "labels/versions#unlock",    :as => "label_versions_unlock"
    match "labels/versions/:origin/to_review(.:format)"   => "labels/versions#to_review", :as => "label_versions_to_review"
    match "labels/versions/:origin/consistency_check(.:format)" => "labels/versions#consistency_check", :as => "label_versions_consistency_check"

  end

end
