Factory.define :xllabel, :class => Iqvoc::XLLabel.base_class do |l|
  l.origin 'Forest'
  l.language 'en'
  l.value 'Forest'
  l.published_at 3.days.ago
end

Factory.define :xllabel_with_association, :parent => :xllabel do |l|
end

Factory.define :user do |u|
  u.forename 'Test'
  u.surname 'User'
  u.email 'testuser@iqvoc.local'
  u.password 'omgomgomg'
  u.password_confirmation 'omgomgomg'
  u.role 'reader'
  u.active true
end
