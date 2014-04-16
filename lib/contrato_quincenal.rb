require ('date')
class ContratoQuincenal
  
  def es_dia_pago?(fecha_de_ejecucion)
    fecha_de_ejecucion.strftime("%A") == "Friday"
  end

  def comprobar?(fecha_de_ejecucion,fecha_inicio_contrato)
    return true
  end
  
  def contrato_mensual?
    false
  end

  def contrato_trimestral?
  	false
  end
  
  def contrato_quincenal?
    true
  end
end