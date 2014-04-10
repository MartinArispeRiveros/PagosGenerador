require './cheques'

require ('date')


class ContratoTrimestral
  cheques = Cheques.new  
  def es_dia_pago?(fecha_de_ejecucion)
    if (cheques.validar_fecha_trimestral(fecha_de_ejecucion,))
      return Date.today
    end
  end
  
  def contrato_mensual?
    false
  end
  
  def contrato_quincenal?
    false
  end

  def contrato_trimestral?
  	true
  end

end