# frozen_string_literal: true

require 'singleton'

#
# This class represents the ATM
#
class Atm
  include Singleton
  attr_accessor :available_cash, :notes

  def initialize
    @available_cash = 0
    @notes = {
      notasDez: 100,
      notasVinte: 100,
      notasCinquenta: 100,
      notasCem: 100
    }
  end
end
