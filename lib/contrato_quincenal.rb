class ContratoQuincenal
  
  def es_dia_pago?(fecha_de_ejecucion,ci)
    fecha_de_ejecucion.strftime("%A") == "Friday"
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