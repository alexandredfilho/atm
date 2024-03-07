# frozen_string_literal: true

#
# This is the ATM controller
#
class AtmController < ApplicationController
  before_action :check_load_cash_in_progress, only: %i[withdraw]

  # Define um número razoável para abastecimento do caixa eletrônico
  MAX_AMOUNT = 10000

  def load_cash
    @cash_loading = params[:caixa][:caixaDisponivel]
    if !@cash_loading
      render json: { error: 'Caixa em uso' }, status: :locked
      return
    end

    # Extrai o número de notas de cada valor inputado pelo usuário
    notas = params[:caixa][:notas]
    load_notes(notas)

    render json: {
      caixa: {
        caixaDisponivel: @cash_loading,
        notas: Atm.instance.notes
      },
      erros: []
    }
  rescue StandardError => e
    render json: {
      caixa: {
        caixaDisponivel: false,
        notas: Atm.instance.notes
      },
      erros: [e.message]
    }, status: :unprocessable_entity
  end

  def withdraw
    amount = params[:saque][:valor].to_i
    notes_to_withdraw = calculate_notes_to_withdraw(amount)

    # Verifica se é possível realizar o saque
    if notes_to_withdraw.nil?
      render json: { error: 'Não é possível realizar o saque com as notas disponíveis' }, status: :unprocessable_entity
      return
    end

    # Atualizar o caixa eletrônico
    update_atm_after_withdraw(notes_to_withdraw)

    render json: { notas_retiradas: notes_to_withdraw }
  end

  private

  def calculate_notes_to_withdraw(amount)
    notes = Atm.instance.notes
    notas_retiradas = {}

    # Definir a ordem das notas de maior para menor valor
    denominations = [:notasCem, :notasCinquenta, :notasVinte, :notasDez]

    denominations.each do |denomination|
      count = amount / value_of(denomination)
      count = [count, notes[denomination]].min
      notas_retiradas[denomination] = count
      amount -= count * value_of(denomination)
    end

    amount == 0 ? notas_retiradas : nil
  end

  def value_of(denomination)
    case denomination
    when :notasCem
      100
    when :notasCinquenta
      50
    when :notasVinte
      20
    when :notasDez
      10
    end
  end

  def update_atm_after_withdraw(notes_to_withdraw)
    notes_to_withdraw.each do |denomination, count|
      Atm.instance.notes[denomination] -= count
      Atm.instance.available_cash -= count * value_of(denomination)
    end
  end

  def check_load_cash_in_progress
    if @cash_loading
      render json: { error: 'Loading cash in progress, please try again later' }, status: :locked
    end
  end

  def load_notes(notas)
    notas_dez = notas[:notasDez].to_i
    notas_vinte = notas[:notasVinte].to_i
    notas_cinquenta = notas[:notasCinquenta].to_i
    notas_cem = notas[:notasCem].to_i

    # Verificar se a quantidade de notas é válida
    if notas_dez < 0 || notas_vinte < 0 || notas_cinquenta < 0 || notas_cem < 0
      render json: { error: 'Invalid note quantity' }, status: :bad_request
      return
    end

    # Verificar se a quantidade total de dinheiro está dentro dos limites razoáveis
    total_amount = notas_dez * 10 + notas_vinte * 20 + notas_cinquenta * 50 + notas_cem * 100
    if total_amount > MAX_AMOUNT
      render json: { error: 'Exceeded maximum amount limit' }, status: :bad_request
      return
    end

    # Atualizar a variável @notes com as notas fornecidas
    Atm.instance.notes[:notasDez] += notas_dez
    Atm.instance.notes[:notasVinte] += notas_vinte
    Atm.instance.notes[:notasCinquenta] += notas_cinquenta
    Atm.instance.notes[:notasCem] += notas_cem
  end
end
