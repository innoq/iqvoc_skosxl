# encoding: UTF-8

require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class LabelTest < ActiveSupport::TestCase
  setup do
    @user = User.create(
      email: 'testuser@iqvoc.local',
      forename: 'Test',
      surname: 'Test',
      password: 'test',
      password_confirmation: 'test',
      role: User.default_role,
      active: true)
  end

  test 'should not create two similar labels' do
    @current_label = Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Forest', published_at: 3.days.ago)
    duplicate = Iqvoc::XLLabel.base_class.new(
      language: 'en', value: 'Forest')
    assert duplicate.save
    refute duplicate.publishable?

    duplicate.value = 'Forest2'
    assert duplicate.publishable?
  end

  test 'label origin generation' do
    l1 = Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Forest', published_at: 3.days.ago)
    assert_match /_[0-9a-z]{8}/, l1.origin

    l2 = Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Forest', origin: 'forest', published_at: 3.days.ago)
    assert_equal 'forest', l2.origin
  end

  test 'should create two labels with equal values but different languages' do
    l1 = Iqvoc::XLLabel.base_class.create(
      language: 'de', value: 'Forest', published_at: 3.days.ago)
    l2 = Iqvoc::XLLabel.base_class.new(
      language: 'en', value: 'Forest', published_at: 3.days.ago)
    assert l2.save
    assert_match /_[0-9a-z]{8}/, l2.origin
  end

  test 'should validate origin for escaping' do
    label = Iqvoc::XLLabel.base_class.new(
      language: 'en', value: 'Forest', published_at: 3.days.ago)
    assert label.publishable?

    label.origin = 'foo-bar'
    assert_equal 'foo-bar', label.origin
    assert label.publishable?

    label.origin = Iqvoc::Origin.new('FoÖ/Bär').to_s
    assert label.publishable?
  end
end
