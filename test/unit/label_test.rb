# encoding: UTF-8

require 'test_helper'

class LabelTest < ActiveSupport::TestCase

  def setup
    @current_label = FactoryGirl.create(:xllabel_with_association)
    @user = FactoryGirl.create(:user)
  end

  def test_should_not_create_more_than_two_versions_of_a_label
    first_new_label = Label::SKOSXL::Base.new(@current_label.attributes)
    second_new_label = Label::SKOSXL::Base.new(@current_label.attributes)
    assert first_new_label.save
    assert_equal second_new_label.save, false
  end

  def test_should_validate_origin_for_escaping
    label = FactoryGirl.build(:xllabel)
    assert label.valid_with_full_validation?

    label.origin = "FoÖ/Bär"
    assert label.invalid_with_full_validation?

    label.origin = OriginMapping.merge("FoÖ/Bär")
    assert label.valid_with_full_validation?
  end

end
