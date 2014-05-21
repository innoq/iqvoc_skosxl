FactoryGirl.define do

  factory :xllabel, :class => Iqvoc::XLLabel.base_class do |l|
    l.language 'en'
    l.value 'Forest'
    l.published_at 3.days.ago
  end

  factory :user do |u|
    u.forename 'Test'
    u.surname 'User'
    u.email 'testuser@iqvoc.local'
    u.password 'omgomgomg'
    u.password_confirmation 'omgomgomg'
    u.role 'reader'
    u.active true
  end

end
