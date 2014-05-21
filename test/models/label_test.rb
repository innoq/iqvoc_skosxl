# encoding: UTF-8

require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class LabelTest < ActiveSupport::TestCase

  setup do
    @user = FactoryGirl.create(:user)
  end

  test "should not create two similar labels" do
    @current_label = FactoryGirl.create(:xllabel)
    duplicate = FactoryGirl.build(:xllabel)
    refute duplicate.save
    duplicate.published_at = nil
    assert duplicate.save
  end

  test "language interpolation for label origin" do
    @current_label = FactoryGirl.create(:xllabel)
    assert_equal "forest-en", @current_label.origin
  end

  test "should create two labels with equal values but different languages" do
    l1 = FactoryGirl.create(:xllabel, :language => "de")
    l2 = FactoryGirl.build(:xllabel, :language => "en")
    assert l2.save
    assert_equal "forest-en", l2.origin
  end

  test "should validate origin for escaping" do
    label = FactoryGirl.build(:xllabel)
    assert label.publishable?

    label.origin = "FoÖ/Bär"
    assert_equal "foo-bar", label.origin
    assert label.publishable?

    label.origin = Iqvoc::Origin.new("FoÖ/Bär").to_s
    assert label.publishable?
  end

end
