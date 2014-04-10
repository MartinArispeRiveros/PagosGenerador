class ContratoMensual
  
  def es_dia_pago?(fecha_de_ejecucion,ci)
    return (fecha_de_ejecucion.next_day.day==1)
  end
  
  def contrato_mensual?
    true
  end

  def contrato_trimestral?
  	false
  end
  
  def contrato_quincenal?
    false
  end
end