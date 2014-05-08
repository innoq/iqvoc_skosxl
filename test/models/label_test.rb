# encoding: UTF-8

require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class LabelTest < ActiveSupport::TestCase

  setup do
    @current_label = FactoryGirl.create(:xllabel_with_association)
    @user = FactoryGirl.create(:user)
  end

  test "should not create two similar labels" do
    first_new_label = Label::SKOSXL::Base.new(@current_label.attributes)
    second_new_label = Label::SKOSXL::Base.new(@current_label.attributes)
    assert first_new_label.save
    assert_equal false, second_new_label.save
  end

  test "language interpolation for label origin" do
    assert_equal "forest-en", @current_label.origin
  end

  test "should create two labels with equal values but different languages" do
    l1 = FactoryGirl.create(:xllabel, :language => "de")
    l2 = FactoryGirl.build(:xllabel, :language => "en")
    assert_equal true, l2.save
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
