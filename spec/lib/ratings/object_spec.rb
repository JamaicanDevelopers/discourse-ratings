# frozen_string_literal: true
require "rails_helper"

describe DiscourseRatings::Object do
  let!(:rating_type) { 'interest' }
  let!(:rating_type_name) { 'Interest' }
  let!(:rating_category) { Fabricate(:category) }
  let!(:rating_tag) { Fabricate(:tag) }

  before do
    DiscourseRatings::RatingType.create(rating_type, rating_type_name)
  end

  context "#create" do
    it "enables rating on a category correctly" do
      DiscourseRatings::Object.create('category', rating_category.rating_key, [rating_type])
      expect(DiscourseRatings::Object.exists?('category', rating_category.rating_key)).to eq(true)
      expect(rating_category.rating_types).to include(rating_type)
    end

    it "enables rating on a tag correctly" do
      DiscourseRatings::Object.create('tag', rating_tag.name, [rating_type])
      expect(DiscourseRatings::Object.exists?('tag', rating_tag.name)).to eq(true)
      expect(rating_tag.rating_types).to include(rating_type)
    end
  end

  context "#destroy" do
    it "disables ratings on all types for a given category/tag" do
      DiscourseRatings::RatingType.create('another_type', 'AnotherType')
      DiscourseRatings::Object.destroy('category', rating_category.rating_key)
      expect(DiscourseRatings::Object.exists?('category', rating_category.rating_key)).to eq(false)
    end
  end
end