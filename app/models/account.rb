# frozen_string_literal: true

#
# This class represents the Accounts
#
class Account
  include ActiveModel::Model
  attr_accessor :id, :balance

  def initialize
    @id = SecureRandom.uuid
    @balance = 0
  end

  def self.find(id)
    Account.new if id.present?
  end
end
