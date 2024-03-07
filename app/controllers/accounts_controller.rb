# frozen_string_literal: true

#
# This is the Accounts controller
#
class AccountsController < ApplicationController
  before_action :set_account, only: %i[deposit balance]

  def create
    @account = Account.new
    render json: { account_number: @account.id }, status: :created
  end

  def deposit
    amount = params[:amount].to_i
    @account.balance += amount
    head :ok
  end

  def balance
    render json: { balance: @account.balance }
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end
end
