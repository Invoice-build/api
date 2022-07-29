# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id         :uuid             not null, primary key
#  code       :text
#  address    :text
#  network    :text             default("mainnet")
#  decimals   :integer          default(18)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  standard   :text             default("erc20")
#
class TokenSerializer < ActiveModel::Serializer
  attributes :id, :code, :address, :decimals, :network, :standard
end
