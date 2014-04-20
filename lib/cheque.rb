require ('date')
class Cheque
  
  attr_accessor :monto
  attr_reader :beneficiario, :ci, :fecha_emision

  def initialize(ci, beneficiario, fecha_emision, monto)
    @ci = ci
    @beneficiario = beneficiario
    @monto = monto
    @fecha_emision = fecha_emision
  end
end