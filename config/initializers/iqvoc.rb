silence_warnings do
  Iqvoc::Label = nil
end

Iqvoc.searchable_class_names = { 'Labeling::SKOSXL::Base' => 'labels',
  'Labeling::SKOSXL::PrefLabel' => 'pref_labels',
  'Labeling::SKOSXL::AltLabel' => 'alt_labels' }
