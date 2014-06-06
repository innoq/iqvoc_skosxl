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
      language: 'en', value: 'Forest', published_at: 3.days.ago)
    refute duplicate.save
    duplicate.published_at = nil
    assert duplicate.save
  end

  test 'language interpolation for label origin' do
    @current_label = Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Forest', published_at: 3.days.ago)
    assert_equal 'forest-en', @current_label.origin
  end

  test 'should create two labels with equal values but different languages' do
    l1 = Iqvoc::XLLabel.base_class.create(
      language: 'de', value: 'Forest', published_at: 3.days.ago)
    l2 = Iqvoc::XLLabel.base_class.new(
      language: 'en', value: 'Forest', published_at: 3.days.ago)
    assert l2.save
    assert_equal 'forest-en', l2.origin
  end

  test 'should validate origin for escaping' do
    label = Iqvoc::XLLabel.base_class.new(
      language: 'en', value: 'Forest', published_at: 3.days.ago)
    assert label.publishable?

    label.origin = 'FoÖ/Bär'
    assert_equal 'foo-bar', label.origin
    assert label.publishable?

    label.origin = Iqvoc::Origin.new('FoÖ/Bär').to_s
    assert label.publishable?
  end

end
