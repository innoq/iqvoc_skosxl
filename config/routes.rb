Iqvoc.localized_routes << lambda do |routing|
  routing.resources :labels

  routing.post "labels/versions/:origin/branch(.:format)"      => "labels/versions#branch",    :as => "label_versions_branch"
  routing.post "labels/versions/:origin/merge(.:format)"       => "labels/versions#merge",     :as => "label_versions_merge"
  routing.post "labels/versions/:origin/lock(.:format)"        => "labels/versions#lock",      :as => "label_versions_lock"
  routing.post "labels/versions/:origin/unlock(.:format)"      => "labels/versions#unlock",    :as => "label_versions_unlock"
  routing.post "labels/versions/:origin/to_review(.:format)"   => "labels/versions#to_review", :as => "label_versions_to_review"
  routing.get "labels/versions/:origin/consistency_check(.:format)" => "labels/versions#consistency_check", :as => "label_versions_consistency_check"
end
