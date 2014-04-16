require ('date')
class ContratoTrimestral 
  
  def es_dia_pago?(fecha_de_ejecucion)
    return (fecha_de_ejecucion.next_day.day==17)
  end
  
  def comprobar?(fecha_de_ejecucion,fecha_inicio_contrato)
    return ((fecha_de_ejecucion.mon-fecha_inicio_contrato.mon)%3 == 0)
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