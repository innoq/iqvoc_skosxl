Iqvoc.localized_routes << lambda do |routing|
  routing.resources :labels

  routing.match "labels/versions/:origin/branch(.:format)"      => "labels/versions#branch",    :as => "label_versions_branch"
  routing.match "labels/versions/:origin/merge(.:format)"       => "labels/versions#merge",     :as => "label_versions_merge"
  routing.match "labels/versions/:origin/lock(.:format)"        => "labels/versions#lock",      :as => "label_versions_lock"
  routing.match "labels/versions/:origin/unlock(.:format)"      => "labels/versions#unlock",    :as => "label_versions_unlock"
  routing.match "labels/versions/:origin/to_review(.:format)"   => "labels/versions#to_review", :as => "label_versions_to_review"
  routing.match "labels/versions/:origin/consistency_check(.:format)" => "labels/versions#consistency_check", :as => "label_versions_consistency_check"
end

Rails.application.routes.draw do
end
