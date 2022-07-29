# frozen_string_literal: true

# == Schema Information
#
# Table name: addresses
#
#  id               :uuid             not null, primary key
#  addressable_id   :uuid
#  addressable_type :text
#  address_1        :text
#  address_2        :text
#  district         :text
#  city             :text
#  postcode         :text
#  country          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
