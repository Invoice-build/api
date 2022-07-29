# frozen_string_literal: true

# == Schema Information
#
# Table name: contacts
#
#  id                  :uuid             not null, primary key
#  business_name       :text
#  contact_name        :text
#  business_reg_number :text
#  tax_number          :text
#  email               :text
#  phone               :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
